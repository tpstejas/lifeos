// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Shared enums used across multiple entities

/// Inference source for AI responses
enum InferenceSource { onDevice, cloud, hybrid }

/// Extension for InferenceSource to get display names
extension InferenceSourceX on InferenceSource {
  String get displayName {
    switch (this) {
      case InferenceSource.onDevice:
        return 'On Device';
      case InferenceSource.cloud:
        return 'Cloud';
      case InferenceSource.hybrid:
        return 'Hybrid';
    }
  }
}

/// Source of captured item
enum ItemSource { voice, text, link, file }

/// Extension for ItemSource to get display names
extension ItemSourceX on ItemSource {
  String get displayName {
    switch (this) {
      case ItemSource.voice:
        return 'Voice';
      case ItemSource.text:
        return 'Text';
      case ItemSource.link:
        return 'Link';
      case ItemSource.file:
        return 'File';
    }
  }
}

/// Status of item in the inbox/library
enum ItemStatus { inbox, active, archived }

/// Extension for ItemStatus to get display names
extension ItemStatusX on ItemStatus {
  String get displayName {
    switch (this) {
      case ItemStatus.inbox:
        return 'Inbox';
      case ItemStatus.active:
        return 'Active';
      case ItemStatus.archived:
        return 'Archived';
    }
  }
}

/// Citation type for RAG responses
enum CitationType { item, collection, external }

/// Extension for CitationType to get display names
extension CitationTypeX on CitationType {
  String get displayName {
    switch (this) {
      case CitationType.item:
        return 'Item';
      case CitationType.collection:
        return 'Collection';
      case CitationType.external:
        return 'External';
    }
  }
}
