import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../../core/openai_service.dart';
import '../../core/openai_client.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late OpenAIClient _openAIClient;
  bool _isLoading = false;
  bool _isListening = false;
  late AnimationController _sparkleController;
  late AnimationController _pulseController;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _pulseAnimation;
  final AudioRecorder _audioRecorder = AudioRecorder();

  // Suggested questions with emojis
  final List<Map<String, String>> _suggestedQuestions = [
    {
      'title': "What's in My Food?",
      'emoji': '🍎',
      'query': 'Can you analyze the nutritional content of my food?'
    },
    {
      'title': 'Show me some healthy recipes!',
      'emoji': '🥗',
      'query': 'Can you suggest some healthy and nutritious recipes?'
    },
    {
      'title': 'Can you help me plan my meals?',
      'emoji': '🍽️',
      'query': 'Help me create a balanced meal plan for the week'
    },
    {
      'title': 'What should I eat for my health goals?',
      'emoji': '🎯',
      'query': 'What foods should I eat to achieve my health and fitness goals?'
    },
    {
      'title': "Can I track today's meals?",
      'emoji': '🥙',
      'query': 'Help me track and analyze my meals for today'
    },
    {
      'title': 'How do calories relate to my activity?',
      'emoji': '🔥',
      'query': 'Explain how calories relate to physical activity and metabolism'
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeOpenAI();
    _initializeAnimations();
  }

  void _initializeOpenAI() {
    final openAIService = OpenAIService();
    _openAIClient = OpenAIClient(openAIService.dio);
  }

  void _initializeAnimations() {
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _sparkleController.dispose();
    _pulseController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required for voice input'),
          ),
        );
      }
    }
  }

  void _startListening() async {
    await _requestMicrophonePermission();

    if (await _audioRecorder.hasPermission()) {
      setState(() {
        _isListening = true;
      });
      // Here you would integrate with speech-to-text
      // For now, just show the listening state
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
  }

  void _sendMessage(String messageText) async {
    if (messageText.trim().isEmpty || _isLoading) return;

    // Add user message
    final userMessage = ChatMessage(
      content: messageText.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
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
                    'You are a helpful nutrition and health assistant named AI. Provide accurate, evidence-based advice about nutrition, fitness, and health. Always encourage users to consult healthcare professionals for medical concerns.'
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

  void _onSuggestedQuestionTapped(String query) {
    _sendMessage(query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerLowest.withAlpha(128),
              theme.colorScheme.surfaceContainerLow.withAlpha(77),
            ],
          ),
        ),
        child: _messages.isEmpty ? _buildWelcomeView() : _buildChatView(),
      ),
    );
  }

  Widget _buildWelcomeView() {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          // Header with back arrow and three dots menu
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Three dots menu action
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 1),

                  // Sparkly AI assistant icon
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                theme.colorScheme.primary.withAlpha(51),
                                theme.colorScheme.primaryContainer
                                    .withAlpha(77),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withAlpha(26),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 60,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              // Sparkle effects
                              AnimatedBuilder(
                                animation: _sparkleAnimation,
                                builder: (context, child) {
                                  return Positioned(
                                    top: 20 + (10 * _sparkleAnimation.value),
                                    right: 20 + (15 * _sparkleAnimation.value),
                                    child: Icon(
                                      Icons.star,
                                      size: 12,
                                      color:
                                          theme.colorScheme.primary.withAlpha(
                                        (255 * (1 - _sparkleAnimation.value))
                                            .round(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              AnimatedBuilder(
                                animation: _sparkleAnimation,
                                builder: (context, child) {
                                  return Positioned(
                                    bottom: 15 + (8 * _sparkleAnimation.value),
                                    left: 25 + (12 * _sparkleAnimation.value),
                                    child: Icon(
                                      Icons.star,
                                      size: 8,
                                      color:
                                          theme.colorScheme.secondary.withAlpha(
                                        (200 * (1 - _sparkleAnimation.value))
                                            .round(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Personalized greeting
                  Text(
                    'Hey, Aslam!',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "I'm your nutrition AI assistant today",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Suggested question buttons
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: _suggestedQuestions.length,
                      itemBuilder: (context, index) {
                        final question = _suggestedQuestions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () =>
                                _onSuggestedQuestionTapped(question['query']!),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      theme.colorScheme.outline.withAlpha(51),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        theme.colorScheme.shadow.withAlpha(13),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    question['emoji']!,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      question['title']!,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Input field at bottom
          Container(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: theme.colorScheme.outline.withAlpha(51),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withAlpha(13),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) => _sendMessage(value),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ask anything...',
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
                  GestureDetector(
                    onTap: _isListening ? _stopListening : _startListening,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isListening
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : Icon(
                              _isListening ? Icons.stop : Icons.mic,
                              color: theme.colorScheme.onPrimary,
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

  Widget _buildChatView() {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(51),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _messages.clear();
                    });
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: Text(
                    'AI Nutrition Assistant',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _messages.clear();
                    });
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        color: theme.colorScheme.surfaceContainerHighest
                            .withAlpha(128),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outline.withAlpha(51),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) => _sendMessage(value),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ask anything...',
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
                  GestureDetector(
                    onTap: _isListening ? _stopListening : _startListening,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isListening
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : Icon(
                              _isListening ? Icons.stop : Icons.mic,
                              color: theme.colorScheme.onPrimary,
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
                Icons.auto_awesome,
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