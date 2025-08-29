import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/openai_service.dart';
import '../../core/openai_client.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late OpenAIClient _openAIClient;
  bool _isLoading = false;
  bool _isStreamingResponse = false;
  String _streamingContent = '';

  @override
  void initState() {
    super.initState();
    _initializeOpenAI();
    _addWelcomeMessage();
  }

  void _initializeOpenAI() {
    final openAIService = OpenAIService();
    _openAIClient = OpenAIClient(openAIService.dio);
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          content:
              "Hi! I'm your nutrition and health assistant. I can help you with:\n\n"
              "• Nutrition advice and meal planning\n"
              "• Calorie counting and macro tracking\n"
              "• Healthy recipe suggestions\n"
              "• Fitness and exercise tips\n"
              "• General health questions\n\n"
              "What would you like to know?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _isLoading) return;

    // Add user message
    final userMessage = ChatMessage(
      content: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _isStreamingResponse = true;
      _streamingContent = '';
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Add a placeholder for the AI response that will be updated in real-time
      final aiMessageIndex = _messages.length;
      setState(() {
        _messages.add(
          ChatMessage(
            content: '',
            isUser: false,
            timestamp: DateTime.now(),
            isStreaming: true,
          ),
        );
      });

      // Prepare messages for API
      final apiMessages = _messages
          .where((msg) => !msg.isStreaming)
          .map((msg) => Message(
                role: msg.isUser ? 'user' : 'assistant',
                content: [
                  {'type': 'text', 'text': msg.content}
                ],
              ))
          .toList();

      // Add system prompt for nutrition/health context
      apiMessages.insert(
          0,
          Message(
            role: 'system',
            content: [
              {
                'type': 'text',
                'text':
                    'You are a helpful nutrition and health assistant. Provide accurate, evidence-based advice about nutrition, fitness, and health. Always encourage users to consult healthcare professionals for medical concerns.'
              }
            ],
          ));

      String fullResponse = '';

      // Stream the response
      await for (final chunk in _openAIClient.streamContentOnly(
        messages: apiMessages,
        model: 'gpt-4o',
        options: {'temperature': 0.7},
      )) {
        if (mounted) {
          fullResponse += chunk;
          setState(() {
            if (aiMessageIndex < _messages.length) {
              _messages[aiMessageIndex] = ChatMessage(
                content: fullResponse,
                isUser: false,
                timestamp: _messages[aiMessageIndex].timestamp,
                isStreaming: true,
              );
            }
          });
          _scrollToBottom();
        }
      }

      // Mark streaming as complete
      if (mounted && aiMessageIndex < _messages.length) {
        setState(() {
          _messages[aiMessageIndex] = ChatMessage(
            content: fullResponse,
            isUser: false,
            timestamp: _messages[aiMessageIndex].timestamp,
            isStreaming: false,
          );
        });
      }
    } catch (e) {
      if (mounted) {
        // Remove the streaming message and add error message
        setState(() {
          _messages.removeLast();
          _messages.add(
            ChatMessage(
              content:
                  "I'm sorry, I'm having trouble responding right now. Please check your internet connection and try again.",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isStreamingResponse = false;
          _streamingContent = '';
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
    _addWelcomeMessage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Nutrition Assistant',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(51),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outline.withAlpha(51),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        onSubmitted: (_) => _sendMessage(),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Ask about nutrition, fitness, or health...',
                          hintStyle: GoogleFonts.inter(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          _messageController.text.trim().isEmpty || _isLoading
                              ? theme.colorScheme.surfaceContainerHighest
                              : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      onPressed:
                          _messageController.text.trim().isEmpty || _isLoading
                              ? null
                              : _sendMessage,
                      icon: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              color: _messageController.text.trim().isEmpty
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onPrimary,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.psychology_rounded,
                size: 64,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AI Nutrition Assistant',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me anything about nutrition, fitness, and health!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 12, top: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.psychology_rounded,
                size: 20,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              margin: isUser
                  ? const EdgeInsets.only(left: 48)
                  : const EdgeInsets.only(right: 48),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 1.5,
                      color: isUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (message.isStreaming) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(message.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isUser
                          ? theme.colorScheme.onPrimary.withAlpha(179)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 12, top: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person_rounded,
                size: 20,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isStreaming;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isStreaming = false,
  });
}
