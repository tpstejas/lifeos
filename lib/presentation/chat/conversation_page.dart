// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/di/providers.dart';
import 'package:lifeos/core/utils/logger.dart';
import 'package:lifeos/data/providers.dart';
import 'package:lifeos/domain/entities/chat_message.dart';
import 'package:lifeos/domain/entities/chat_session.dart';
import 'package:lifeos/domain/entities/enums.dart';
import 'package:lifeos/domain/repositories/repository_interfaces.dart';

/// Conversation page - View a specific chat conversation
class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> with LoggerMixin {
  ChatSession? _session;
  final List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    setState(() => _isLoading = true);
    try {
      final chatRepository = ref.read(chatRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final userId = authState.userId ?? 'anonymous';

      final session = await chatRepository.getChatSession(widget.conversationId);
      final messages = await chatRepository.getChatMessages(widget.conversationId);

      if (mounted) {
        setState(() {
          _session = session;
          _messages.clear();
          _messages.addAll(messages);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      logE('Failed to load conversation', error: e);
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Failed to load conversation');
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending || _session == null) return;

    setState(() => _isSending = true);

    try {
      final chatRepository = ref.read(chatRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final userId = authState.userId ?? 'anonymous';

      // Add user message
      final userMessage = ChatMessage(
        id: '',
        sessionId: _session!.id,
        role: ChatRole.user,
        content: text,
        timestamp: DateTime.now(),
        userId: userId,
      );
      await chatRepository.addChatMessage(userMessage);

      // Clear input
      _controller.clear();

      // Get AI response
      await _getAIResponse(text);

      if (mounted) {
        _scrollToBottom();
      }
    } catch (e) {
      logE('Failed to send message', error: e);
      if (mounted) {
        _showSnackBar('Failed to send: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _getAIResponse(String query) async {
    // TODO: Implement actual RAG chat with Cloud Functions
    // For now, simulate a response
    await Future.delayed(const Duration(seconds: 1));

    final chatRepository = ref.read(chatRepositoryProvider);
    final sessionId = _session?.id ?? widget.conversationId;

    final assistantMessage = ChatMessage(
      id: '',
      sessionId: sessionId,
      role: ChatRole.assistant,
      content: 'This is a simulated response. The actual implementation will connect to the hybrid AI router with RAG capabilities.',
      source: InferenceSource.hybrid,
      citations: [
        Citation(
          itemId: 'sample_item_1',
          title: 'Sample Reference Item',
          snippet: 'This is a relevant excerpt from your library...',
        ),
      ],
      timestamp: DateTime.now(),
      userId: 'anonymous',
    );

    await chatRepository.addChatMessage(assistantMessage);

    if (mounted) {
      setState(() {
        _messages.add(assistantMessage);
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Conversation')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_session?.title ?? 'Conversation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showConversationOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Source indicator
          if (_messages.isNotEmpty)
            _SourceIndicatorBanner(
              source: _messages.last.inferenceSource ?? InferenceSource.hybrid,
              onTap: () => _showSourceInfo(),
            ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _ChatMessageWidget(message: message);
              },
            ),
          ),

          // Input
          _ChatInput(
            controller: _controller,
            onSend: _sendMessage,
            isSending: _isSending,
          ),
        ],
      ),
    );
  }

  void _showConversationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename Conversation'),
              onTap: () {
                Navigator.pop(context);
                _renameConversation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Conversation', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteConversation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Export Conversation'),
              onTap: () {
                Navigator.pop(context);
                _exportConversation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _renameConversation() {
    final controller = TextEditingController(text: _session?.title ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Conversation'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new title'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty && _session != null) {
                Navigator.pop(context);
                try {
                  final chatRepository = ref.read(chatRepositoryProvider);
                  final updatedSession = _session!.copyWith(title: newTitle);
                  await chatRepository.updateChatSession(updatedSession);
                  if (mounted) {
                    setState(() => _session = updatedSession);
                    _showSnackBar('Conversation renamed');
                  }
                } catch (e) {
                  logE('Failed to rename', error: e);
                  _showSnackBar('Failed to rename');
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteConversation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && _session != null) {
      try {
        final chatRepository = ref.read(chatRepositoryProvider);
        await chatRepository.deleteChatSession(_session!.id);
        if (mounted) {
          context.pop();
          _showSnackBar('Conversation deleted');
        }
      } catch (e) {
        logE('Failed to delete', error: e);
        _showSnackBar('Failed to delete');
      }
    }
  }

  void _exportConversation() {
    _showSnackBar('Export feature coming soon');
  }

  void _showSourceInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Source Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This conversation uses hybrid AI inference.'),
            const SizedBox(height: 16),
            const Text('Sources:'),
            const Text('• On-device (privacy-first)'),
            const Text('• Cloud (complex reasoning)'),
            const Text('• Hybrid (balanced)'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

/// Source indicator banner
class _SourceIndicatorBanner extends StatelessWidget {
  const _SourceIndicatorBanner({
    required this.source,
    required this.onTap,
  });

  final InferenceSource source;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData icon;
    String label;
    Color color;

    switch (source) {
      case InferenceSource.onDevice:
        icon = Icons.phone_android;
        label = 'On-Device';
        color = Colors.green;
        break;
      case InferenceSource.cloud:
        icon = Icons.cloud;
        label = 'Cloud';
        color = Colors.blue;
        break;
      case InferenceSource.hybrid:
        icon = Icons.hub;
        label = 'Hybrid';
        color = Colors.purple;
        break;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: color.withValues(alpha: 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              'Powered by $label AI',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chat message widget
class _ChatMessageWidget extends StatelessWidget {
  const _ChatMessageWidget({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == ChatRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.smart_toy,
                size: 16,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (message.citations.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _CitationsWidget(citations: message.citations),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isUser
                          ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Icon(
                Icons.person,
                size: 16,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Citations widget
class _CitationsWidget extends StatelessWidget {
  const _CitationsWidget({required this.citations});

  final List<Citation> citations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sources:',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        ...citations.map((citation) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () => AppLogger.d('Citation tapped: ${citation.itemId}',
                    tag: 'ConversationPage'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        citation.title,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        citation.snippet,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

/// Chat input widget
class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.onSend,
    required this.isSending,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Ask me anything...',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              onPressed: isSending ? null : onSend,
              child: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}