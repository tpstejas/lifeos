// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lifeos/core/utils/logger.dart';

/// Chat page - RAG chat with your library
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> with LoggerMixin {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      role: _MessageRole.assistant,
      content:
          'Hi! I\'m your LifeOS assistant. Ask me anything about your saved items.',
      source: InferenceSource.hybrid,
      citations: [],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => logD('History tapped'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => logD('Settings tapped'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Source indicator
          _SourceIndicatorBanner(
            source: _messages.last.source,
            onTap: () => logD('Source tapped'),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
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
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        role: _MessageRole.user,
        content: text,
        source: InferenceSource.onDevice,
        citations: [],
      ));
      _controller.clear();

      // Simulate AI response
      _messages.add(_ChatMessage(
        role: _MessageRole.assistant,
        content:
            'This is a simulated response. In the real app, this would come from the hybrid AI router with citations.',
        source: InferenceSource.hybrid,
        citations: [
          Citation(
              itemId: 'item_1',
              title: 'Sample Item',
              snippet: 'Relevant excerpt...'),
        ],
      ));
    });
  }
}

enum _MessageRole { user, assistant }

enum InferenceSource { onDevice, cloud, hybrid }

class _ChatMessage {
  const _ChatMessage({
    required this.role,
    required this.content,
    required this.source,
    required this.citations,
  });

  final _MessageRole role;
  final String content;
  final InferenceSource source;
  final List<Citation> citations;
}

class Citation {
  const Citation({
    required this.itemId,
    required this.title,
    required this.snippet,
  });

  final String itemId;
  final String title;
  final String snippet;
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
        color: color.withOpacity(0.1),
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

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.role == _MessageRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                    tag: 'ChatPage'),
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
  });

  final TextEditingController controller;
  final VoidCallback onSend;

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
              onPressed: onSend,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
