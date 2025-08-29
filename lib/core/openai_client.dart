import 'package:dio/dio.dart';
import 'dart:convert';

class OpenAIClient {
  final Dio dio;

  OpenAIClient(this.dio);

  /// Generates a text response
  /// Sends a POST request to /chat/completions with messages and model.
  Future<Completion> createChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          if (options != null) ...options,
        },
      );
      final text = response.data['choices'][0]['message']['content'];
      return Completion(text: text);
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  /// Streams a text response
  /// Uses server-sent events (SSE) from /chat/completions with stream=true.
  Stream<StreamCompletion> streamChatCompletion({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async* {
    try {
      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': messages
              .map((m) => {
                    'role': m.role,
                    'content': m.content,
                  })
              .toList(),
          'stream': true,
          if (options != null) ...options,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream;
      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') break;

          final json = jsonDecode(data) as Map<String, dynamic>;
          final delta = json['choices'][0]['delta'] as Map<String, dynamic>;
          final content = delta['content'] ?? '';
          final finishReason = json['choices'][0]['finish_reason'];
          final systemFingerprint = json['system_fingerprint'];

          yield StreamCompletion(
            content: content,
            finishReason: finishReason,
            systemFingerprint: systemFingerprint,
          );

          // If finish reason is provided, this is the final chunk
          if (finishReason != null) break;
        }
      }
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data['error']['message'] ?? e.message,
      );
    }
  }

  // A more user-friendly wrapper for streaming that just yields content strings
  Stream<String> streamContentOnly({
    required List<Message> messages,
    String model = 'gpt-4o',
    Map<String, dynamic>? options,
  }) async* {
    await for (final chunk in streamChatCompletion(
      messages: messages,
      model: model,
      options: options,
    )) {
      if (chunk.content.isNotEmpty) {
        yield chunk.content;
      }
    }
  }
}

/// Support classes
class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;

  Completion({required this.text});
}

class StreamCompletion {
  final String content;
  final String? finishReason;
  final String? systemFingerprint;

  StreamCompletion({
    required this.content,
    this.finishReason,
    this.systemFingerprint,
  });
}

class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAIException: $statusCode - $message';
}
