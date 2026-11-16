// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:lifeos/data/local/database/daos/item_dao.dart';
import 'package:lifeos/domain/entities/item.dart';
import 'package:lifeos/domain/entities/chat_message.dart' hide InferenceSource;
import 'package:lifeos/ai/ai_models.dart';
import 'package:lifeos/domain/entities/enums.dart';
import 'hybrid_router.dart';
import 'embedding_engine.dart';

/// RAG (Retrieval-Augmented Generation) Service
/// Combines vector search with hybrid AI router for cited responses
class RAGService {
  RAGService({
    required HybridAIRouter router,
    required EmbeddingEngine embeddingEngine,
    required ItemDao itemDao,
    this.maxContextItems = 5,
    this.minSimilarity = 0.3,
    this.maxContextTokens = 3000,
  })  : _router = router,
        _embeddingEngine = embeddingEngine,
        _itemDao = itemDao;

  final HybridAIRouter _router;
  final EmbeddingEngine _embeddingEngine;
  final ItemDao _itemDao;
  final int maxContextItems;
  final double minSimilarity;
  final int maxContextTokens;

  /// Process a chat query with RAG
  Future<RAGResponse> query({
    required String query,
    required String userId,
    String? collectionId,
    AIModel? model,
    InferencePreference preference = InferencePreference.auto,
    List<AIMessage>? conversationHistory,
  }) async {
    // 1. Generate embedding for the query
    final queryEmbedding = await _embeddingEngine.embed(query);

    // 2. Search for relevant items using vector similarity
    final relevantItems = await _searchRelevantItems(
      queryEmbedding,
      userId,
      collectionId: collectionId,
    );

    // 3. Build context from relevant items
    final context = _buildContext(relevantItems);

    // 4. Create AI request with context
    final request = AIRequest(
      prompt: query,
      systemPrompt: _buildSystemPrompt(),
      context: [
        ...?conversationHistory,
        if (context.isNotEmpty)
          AIMessage(
            role: AIMessageRole.system,
            content: 'Relevant context from your knowledge base:\n$context',
          ),
      ],
      model: model,
      stream: false,
    );

    // 5. Route to appropriate AI (on-device or cloud)
    final response = await _router.process(request, preference);

    // 6. Build citations from relevant items
    final citations = _buildCitations(relevantItems);

    return RAGResponse(
      content: response.content,
      model: response.model,
      source: response.source,
      citations: citations,
      usage: response.usage,
      relevantItemIds: relevantItems.map((e) => e.item.id).toList(),
    );
  }

  /// Stream a chat query with RAG
  Stream<RAGStreamChunk> streamQuery({
    required String query,
    required String userId,
    String? collectionId,
    AIModel? model,
    InferencePreference preference = InferencePreference.auto,
    List<AIMessage>? conversationHistory,
  }) async* {
    // 1. Generate embedding for the query
    final queryEmbedding = await _embeddingEngine.embed(query);

    // 2. Search for relevant items
    final relevantItems = await _searchRelevantItems(
      queryEmbedding,
      userId,
      collectionId: collectionId,
    );

    // 3. Build context
    final context = _buildContext(relevantItems);

    // 4. Create AI request
    final request = AIRequest(
      prompt: query,
      systemPrompt: _buildSystemPrompt(),
      context: [
        ...?conversationHistory,
        if (context.isNotEmpty)
          AIMessage(
            role: AIMessageRole.system,
            content: 'Relevant context from your knowledge base:\n$context',
          ),
      ],
      model: model,
      stream: true,
    );

    // 5. Stream response
    final citations = _buildCitations(relevantItems);
    bool firstChunk = true;

    await for (final chunk in _router.stream(request, preference)) {
      yield RAGStreamChunk(
        content: chunk,
        citations: firstChunk ? citations : [],
        relevantItemIds:
            firstChunk ? relevantItems.map((e) => e.item.id).toList() : [],
        isComplete: false,
      );
      firstChunk = false;
    }

    // Final chunk
    yield RAGStreamChunk(
      content: '',
      citations: [],
      relevantItemIds: [],
      isComplete: true,
    );
  }

  /// Search for relevant items using vector similarity
  Future<List<ScoredItem>> _searchRelevantItems(
    List<double> queryEmbedding,
    String userId, {
    String? collectionId,
  }) async {
    // Search in the database using vector similarity
    final results = await _itemDao.searchByEmbedding(
      queryEmbedding,
      userId: userId,
      collectionId: collectionId,
      limit: maxContextItems * 2, // Get more, filter by similarity
    );

    // Filter by minimum similarity and take top-k
    final scored = <ScoredItem>[];
    for (final itemData in results) {
      if (itemData.embedding != null) {
        final item = _itemDao.toDomain(itemData);
        final similarity = EmbeddingEngine.cosineSimilarity(
          queryEmbedding,
          itemData.embedding!,
        );
        if (similarity >= minSimilarity) {
          scored.add(ScoredItem(item: item, similarity: similarity));
        }
      }
    }

    // Sort by similarity descending
    scored.sort((a, b) => b.similarity.compareTo(a.similarity));

    return scored.take(maxContextItems).toList();
  }

  /// Build context string from relevant items
  String _buildContext(List<ScoredItem> items) {
    if (items.isEmpty) return '';

    final contextParts = <String>[];
    var tokenCount = 0;

    for (final scoredItem in items) {
      final item = scoredItem.item;
      final content = _formatItemForContext(item);

      // Rough token estimate
      final estimatedTokens = content.length ~/ 4;
      if (tokenCount + estimatedTokens > maxContextTokens) break;

      contextParts
          .add('[${scoredItem.similarity.toStringAsFixed(2)}] $content');
      tokenCount += estimatedTokens;
    }

    return contextParts.join('\n\n---\n\n');
  }

  String _formatItemForContext(Item item) {
    final buffer = StringBuffer();

    if (item.title.isNotEmpty) {
      buffer.write('Title: ${item.title}\n');
    }
    if (item.content?.isNotEmpty == true) {
      buffer.write('Content: ${item.content}\n');
    }
    if (item.summary?.isNotEmpty == true) {
      buffer.write('Summary: ${item.summary}\n');
    }
    if (item.sourceUrl?.isNotEmpty == true) {
      buffer.write('Source: ${item.sourceUrl}\n');
    }
    buffer.write('Type: ${item.type.name}\n');
    buffer.write('Created: ${item.createdAt.toIso8601String()}');

    return buffer.toString();
  }

  /// Build system prompt for RAG
  String _buildSystemPrompt() {
    return '''
You are LifeOS, an AI assistant that helps users manage their personal knowledge base.
You have access to the user's captured content (notes, links, PDFs, images, recordings).

Guidelines:
- Answer based on the provided context from the user's knowledge base
- Cite sources using the format [Source: title] when referencing specific items
- If context is insufficient, say so and offer to help with what you know
- Be concise but thorough
- Maintain a helpful, conversational tone
''';
  }

  /// Build citations from relevant items
  List<Citation> _buildCitations(List<ScoredItem> items) {
    return items.map((scored) {
      final item = scored.item;
      return Citation(
        itemId: item.id,
        title: item.title.isNotEmpty ? item.title : 'Untitled',
        snippet: item.content?.isNotEmpty == true
            ? item.content!.substring(0, math.min(200, item.content!.length))
            : (item.summary ?? ''),
        score: scored.similarity,
        metadata: {
          'sourceUrl': item.sourceUrl,
          'itemType': item.type.name,
          'createdAt': item.createdAt.toIso8601String(),
        },
      );
    }).toList();
  }

  /// Generate summary of items
  Future<String> summarizeItems(
    List<Item> items, {
    InferencePreference preference = InferencePreference.auto,
  }) async {
    if (items.isEmpty) return 'No items to summarize.';

    final content = items.map(_formatItemForContext).join('\n\n---\n\n');

    final request = AIRequest(
      prompt:
          'Summarize the following items into key points and themes:\n\n$content',
      systemPrompt:
          'You are a summarization expert. Create concise, structured summaries with key themes.',
      model: AIModel.gemini15Flash,
      stream: false,
    );

    final response = await _router.process(request, preference);
    return response.content;
  }

  /// Extract tasks/action items from content
  Future<List<String>> extractTasks(
    String content, {
    InferencePreference preference = InferencePreference.auto,
  }) async {
    final request = AIRequest(
      prompt:
          'Extract actionable tasks from this content. Return as a numbered list:\n\n$content',
      systemPrompt:
          'Extract specific, actionable tasks. Format as numbered list.',
      model: AIModel.gemini15Flash,
      stream: false,
    );

    final response = await _router.process(request, preference);

    // Parse numbered list
    return response.content
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  /// Generate tags for an item
  Future<List<String>> generateTags(
    Item item, {
    InferencePreference preference = InferencePreference.auto,
  }) async {
    final content = _formatItemForContext(item);

    final request = AIRequest(
      prompt: 'Generate 5-10 relevant tags for this content:\n\n$content',
      systemPrompt:
          'Generate relevant, specific tags. Return as comma-separated list.',
      model: AIModel.geminiNanoText,
      stream: false,
    );

    final response = await _router.process(request, preference);

    return response.content
        .split(',')
        .map((t) => t.trim().toLowerCase())
        .where((t) => t.isNotEmpty)
        .toList();
  }
}

/// Scored item with similarity
class ScoredItem {
  const ScoredItem({
    required this.item,
    required this.similarity,
  });

  final Item item;
  final double similarity;
}

/// RAG response with citations
class RAGResponse {
  const RAGResponse({
    required this.content,
    required this.model,
    required this.source,
    required this.citations,
    this.usage,
    required this.relevantItemIds,
  });

  final String content;
  final AIModel model;
  final InferenceSource source;
  final List<Citation> citations;
  final AIUsage? usage;
  final List<String> relevantItemIds;
}

/// RAG streaming chunk
class RAGStreamChunk {
  const RAGStreamChunk({
    required this.content,
    required this.citations,
    required this.relevantItemIds,
    required this.isComplete,
  });

  final String content;
  final List<Citation> citations;
  final List<String> relevantItemIds;
  final bool isComplete;
}
