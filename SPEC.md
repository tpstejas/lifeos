# LifeOS - Your Second Brain with Hybrid AI

## Project Overview
**Name**: LifeOS (working title)
**Tagline**: "Capture everything. Organize automatically. Chat with your life."
**Hackathon**: #BuildHybridAI 2026 (Firebase Hybrid AI Hackathon)
**Timeline**: Nov 11 - Nov 30, 2026 (19 days)
**Prize Pool**: $30,000

## Core Concept
A **hybrid AI-powered personal knowledge management app** that serves as your "second brain":
- **Capture anywhere**: Voice, text, links, PDFs, images, screen recordings, share extension
- **Auto-organize**: Hybrid AI categorizes, extracts tasks, dates, entities, summarizes
- **Chat with your library**: RAG over all saved content (on-device embeddings + cloud synthesis)
- **AI Digests**: Daily/weekly/monthly personalized summaries
- **Smart notifications**: Deadlines, hackathons, internships, follow-ups
- **Offline-first**: Full functionality offline, syncs when online

## The Problem (Why This Wins)
> "Too much noise in life - too many things to save. Reels say 'watch this', real life says 'do this', emails say 'apply here'. Scattered across apps, lost in chaos."

**LifeOS solves**: One inbox → AI organizes → Actionable outputs (tasks, calendar, digests, chat)

## Target Platforms
- **Primary**: Flutter (iOS, Android) - Share Extension, Background Fetch, Local Notifications
- **Secondary**: Flutter Web (Firebase Hosting)
- **Firebase Services**: AI Logic, Auth, Firestore, Storage, Functions, App Check, Remote Config, Messaging

## Key Features (MVP for Hackathon)

### 1. Universal Capture Inbox
- **Share Extension** (iOS/Android): Save from any app (Reels, Safari, Email, PDFs)
- **Quick Capture**: Floating action button → Voice note / Text / Photo / Link
- **Background Fetch**: Auto-save clipboard, screenshots (with permission)
- **Input Types**: Text, Voice (Whisper on-device), Links (auto-extract), PDFs, Images (OCR), YouTube/Reels (transcript)

### 2. Hybrid AI Processing Pipeline
```
Input → On-Device (Instant)                    → Cloud (Deep)
       ├── Quick categorization (Task/Learn/Ref)   ├── Deep summarization
       ├── Entity extraction (dates, people, $)    ├── Cross-doc synthesis
       ├── Embedding generation (local)            ├── Complex RAG reasoning
       ├── Task parsing (due dates, priorities)    ├── Digest generation
       └── Offline queue                           └── Model fine-tuning
```

### 3. Smart Organization (Auto + Manual)
- **Collections**: Tasks, Learning, References, Ideas, Opportunities
- **Auto-tags**: #hackathon #internship #deadline #urgent #later
- **Smart Views**: Today, This Week, Someday, By Topic, By Source
- **Bidirectional Links**: Connect related items automatically

### 4. Chat with Your Library (RAG)
- **On-device**: Semantic search over local embeddings → instant results
- **Cloud**: Multi-document synthesis, reasoning, follow-up questions
- **Hybrid**: "What did I save about hackathons?" → shows items + AI summary
- **Citations**: Every answer links to source items

### 5. AI Digests (The Killer Feature)
- **Daily Morning Brief**: "3 tasks due, 2 hackathons ending, 1 article to read"
- **Weekly Review**: "You saved 47 items. Completed 12 tasks. Top topics: AI, Internships"
- **Monthly Synthesis**: "Patterns: You collect but don't act on learning items. Suggestion: ..."
- **Delivery**: In-app, Push notification, Email (via Firebase Functions)

### 6. Smart Notifications & Reminders
- **Deadline alerts**: Hackathon submissions, internship applications, assignments
- **Follow-up nudges**: "You saved this article 3 days ago - read it?"
- **Opportunity alerts**: "New hackathon matching your interests posted"
- **Contextual**: Location-based (library → "review saved papers"), Time-based

### 7. Offline-First Architecture
- **Local DB**: Drift (SQLite) - all items, embeddings, chat history
- **Local AI**: MediaPipe/Whisper for voice, Transformers.js for embeddings
- **Sync Engine**: Firestore + conflict resolution (last-write-wins + manual merge)
- **Background Sync**: WorkManager / BGAppRefreshTask

## Technical Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                        Flutter App                             │
├────────────────────────────────────────────────────────────────┤
│  UI Layer                                                       │
│  ├── Inbox (Capture)   ├── Library (Browse)   ├── Chat (RAG)  │
│  ├── Digests           ├── Calendar/Tasks     ├── Settings    │
│  └── Share Extension / Widget / Notification Actions          │
├────────────────────────────────────────────────────────────────┤
│  Hybrid AI Layer                                               │
│  ├── OnDeviceProcessor    (MediaPipe, Transformers.js, AI Core) │
│  ├── CloudProcessor       (Firebase AI Logic, Vertex AI)       │
│  ├── HybridRouter         (Decides on-device vs cloud)         │
│  ├── EmbeddingEngine      (Local + Cloud sync)                 │
│  ├── DigestGenerator      (Scheduled cloud function)           │
│  └── NotificationEngine   (Local + FCM)                        │
├────────────────────────────────────────────────────────────────┤
│  Data Layer                                                    │
│  ├── Local DB (Drift)     ├── Sync Engine (Firestore)         │
│  ├── Local Vector Store   ├── Cloud Vector Store (Firestore)   │
│  ├── Offline Queue        └── File Storage (Firebase Storage)  │
├────────────────────────────────────────────────────────────────┤
│  Firebase Services                                             │
│  ├── firebase_ai          ├── cloud_firestore                  │
│  ├── firebase_auth        ├── firebase_storage                 │
│  ├── firebase_messaging   ├── firebase_functions               │
│  ├── firebase_remote_config ├── firebase_app_check             │
└────────────────────────────────────────────────────────────────┘
```

## Data Models

### Item (Core Entity)
```dart
class Item {
  String id;
  ItemType type; // task, note, link, pdf, image, voice, video
  String title;
  String content; // markdown, extracted text, transcript
  String? sourceUrl;
  String? filePath; // local file (PDF, image, audio)
  List<double> embedding; // on-device embedding vector
  List<String> tags; // auto + manual
  Collection collection; // tasks, learning, references, ideas, opportunities
  ItemStatus status; // inbox, organized, archived, done
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? dueDate;
  Priority priority; // none, low, medium, high, urgent
  Map<String, dynamic> metadata; // extracted entities, summary, etc.
  bool isSynced;
  String? cloudId;
}
```

### Collection
```dart
enum Collection { tasks, learning, references, ideas, opportunities }
```

### Digest
```dart
class Digest {
  String id;
  DigestPeriod period; // daily, weekly, monthly
  DateTime generatedAt;
  String summary; // AI-generated markdown
  List<DigestSection> sections;
  bool isRead;
  String? notificationId;
}

class DigestSection {
  String title;
  List<String> itemIds;
  String aiInsight;
  DigestSectionType type; // tasks, learning, opportunities, patterns
}
```

### ChatMessage
```dart
class ChatMessage {
  String id;
  String conversationId;
  MessageRole role; // user, assistant
  String content;
  List<Citation> citations; // links to Items
  InferenceSource source; // onDevice, cloud, hybrid
  int latencyMs;
  DateTime timestamp;
}
```

## Hackathon Winning Criteria Alignment

| Criterion | LifeOS Approach |
|-----------|-----------------|
| **Innovation** | First hybrid AI second-brain: on-device capture/embeddings + cloud synthesis/digests |
| **Impact** | Solves universal "information overload" - judges feel the pain personally |
| **Usability** | Share extension → instant save → auto-organize → digest → chat. Non-tech demo in 30 sec |
| **Solution Quality** | Production offline sync, hybrid routing, RAG with citations, scheduled digests |
| **Category Alignment** | Core use case: Hybrid AI apps with Firebase AI Logic (on-device + cloud) |

## Demo Flow (3 Minutes)

1. **Capture** (30s): Share Reel from Instagram → "Saved! Auto-tagged #hackathon #deadline"
2. **Organize** (30s): Open app → Inbox shows item → AI extracted date, created task, added to calendar
3. **Offline** (30s): Airplane mode ON → Voice note "Remember to apply for Google internship" → Instant save + task
4. **Chat** (30s): "What hackathons did I save?" → RAG answer with citations + "Apply by Nov 30"
5. **Digest** (30s): Pull down → "Daily Brief: 2 deadlines tomorrow, 1 hackathon ending, 3 unread articles"
6. **Sync** (30s): Airplane mode OFF → "Syncing 5 items..." → Green checkmarks → Digest updated

## Technical Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| On-device embeddings slow/large | Use quantized models (Transformers.js, MediaPipe); batch process |
| Share Extension complexity | Start with basic share → enhance; use Flutter platform channels |
| Vector search on-device | Drift + custom vector index; or use sqlite-vec extension |
| Digest generation cost | Firebase Functions with scheduled triggers; cache results |
| iOS background limits | Use BGAppRefreshTask + Push notifications as fallback |
| App Store / Play Store review | Demo on TestFlight / Firebase App Distribution; document IAP |
| RAG hallucination | Citations mandatory; "I don't know" if no sources |

## Success Metrics

- [ ] App builds/runs on iOS + Android + Web
- [ ] Share Extension works (save from Safari, Instagram, etc.)
- [ ] On-device processing: categorize, extract entities, embed (<2s)
- [ ] Cloud fallback: deep summary, RAG chat, digest generation
- [ ] Offline: Full capture/organize/chat works in airplane mode
- [ ] Sync: Conflict-free merge, background sync, progress UI
- [ ] Digests: Daily/weekly generated via Functions, delivered via FCM
- [ ] Notifications: Local + FCM, actionable (mark done, snooze, open)
- [ ] Chat: Streaming responses, citations, hybrid routing indicator
- [ ] Clean architecture, <500 lines/file, 80%+ test coverage

## Timeline (19 Days)

| Phase | Days | Deliverable |
|-------|------|-------------|
| **Setup & Firebase** | 1-2 | Flutter project, Firebase config, CI/CD, Share Extension scaffold |
| **Local DB & Capture** | 3-4 | Drift schema, Inbox UI, Share Extension, Voice/Text capture |
| **On-Device AI** | 5-7 | Categorization, entity extraction, embeddings (Transformers.js/MediaPipe) |
| **Cloud AI & Hybrid Router** | 8-10 | Firebase AI Logic, RAG, routing logic, streaming chat |
| **Sync Engine** | 11-12 | Firestore sync, conflict resolution, offline queue, vector sync |
| **Digests & Notifications** | 13-14 | Scheduled Functions, digest UI, FCM + local notifications |
| **Polish & Demo Prep** | 15-17 | Animations, empty states, demo script, screenshots, video |
| **Testing & Ship** | 18-19 | E2E tests, Devpost submission, TestFlight/Firebase Distribution |

## Stack Summary

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.24+ (Dart 3.5+) |
| **State** | Riverpod |
| **Local DB** | Drift (type-safe SQLite) + sqlite-vec (vector search) |
| **Local AI** | Transformers.js (WASM), MediaPipe Tasks, Whisper.cpp |
| **Firebase** | firebase_ai, firebase_auth, cloud_firestore, firebase_storage, firebase_messaging, firebase_functions, firebase_remote_config, firebase_app_check, firebase_core |
| **Platform** | share_plus, flutter_local_notifications, workmanager, bg_app_refresh, url_launcher, file_picker, image_picker, record |
| **UI** | Material 3, go_router, flutter_markdown, fl_chart (digest viz) |
| **Testing** | flutter_test, integration_test, patrol, mocktail |
| **CI/CD** | GitHub Actions → Firebase App Distribution / TestFlight |
| **Deploy** | Firebase Hosting (web), TestFlight (iOS), Play Console (Android) |

## File Structure

```
lifeos/
├── .github/workflows/           # CI/CD
├── android/                     # Android config + Share Extension
├── ios/                         # iOS config + Share Extension
├── web/                         # Web config
├── lib/
│   ├── main.dart               # Entry point
│   ├── firebase_options.dart
│   ├── core/
│   │   ├── config/             # App config, constants, env
│   │   ├── di/                 # Dependency injection (Riverpod)
│   │   ├── errors/             # Error handling, failure types
│   │   ├── utils/              # Helpers, extensions
│   │   └── platform/           # Platform channels (share, notifications)
│   ├── data/
│   │   ├── local/
│   │   │   ├── database/       # Drift database, tables, DAOs
│   │   │   ├── vector_store/   # Local vector index (sqlite-vec)
│   │   │   └── embedding/      # On-device embedding generation
│   │   ├── remote/
│   │   │   ├── firestore/      # Firestore repositories
│   │   │   ├── storage/        # Firebase Storage
│   │   │   ├── functions/      # Cloud Functions client
│   │   │   └── messaging/      # FCM
│   │   ├── repository/         # Repository implementations
│   │   └── sync/
│   │       ├── sync_engine.dart
│   │       ├── conflict_resolver.dart
│   │       └── offline_queue.dart
│   ├── domain/
│   │   ├── entities/           # Item, Collection, Digest, ChatMessage
│   │   ├── repositories/       # Repository interfaces
│   │   └── usecases/
│   │       ├── capture_item.dart
│   │       ├── process_item.dart
│   │       ├── chat_with_library.dart
│   │       ├── generate_digest.dart
│   │       └── sync_items.dart
│   ├── presentation/
│   │   ├── inbox/              # Capture screen, quick actions
│   │   ├── library/            # Browse, search, filter, collections
│   │   ├── chat/               # RAG chat interface
│   │   ├── digests/            # Daily/weekly/monthly views
│   │   ├── tasks/              # Task management, calendar view
│   │   ├── settings/           # Preferences, sync status, subscription
│   │   ├── widgets/            # Reusable: ItemCard, TagChip, SourceIndicator
│   │   └── providers/          # Riverpod providers
│   └── ai/
│       ├── hybrid_router.dart
│       ├── ondevice_processor.dart
│       ├── cloud_processor.dart
│       ├── embedding_engine.dart
│       ├── rag_service.dart
│       ├── digest_generator.dart
│       └── notification_engine.dart
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── functions/                   # Firebase Cloud Functions (TypeScript)
│   ├── src/
│   │   ├── digests/            # Scheduled digest generation
│   │   ├── rag/                # Cloud RAG endpoints
│   │   ├── embeddings/         # Cloud embedding generation
│   │   └── notifications/      # FCM triggers
│   └── package.json
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
└── SPEC.md (this file)
```

## Monetization (Post-Hackathon)

| Tier | Features |
|------|----------|
| **Free** | Unlimited capture, 3 collections, daily digest, 10 cloud chats/day |
| **Pro ($4.99/mo)** | Unlimited collections, weekly/monthly digests, unlimited cloud chat, OCR, priority sync |
| **Team ($12.99/mo/user)** | Shared collections, collaborative digests, admin dashboard, SSO |

## Competitive Differentiation

| App | Gap | LifeOS Advantage |
|-----|-----|------------------|
| **Qind** | No hybrid AI, cloud-only | On-device instant capture + embeddings |
| **Linkwise** | iOS only, no digests | Cross-platform, AI digests, notifications |
| **Notion** | Heavy, no auto-organize | Lightweight, AI-first, mobile-native |
| **Obsidian** | Desktop-first, manual | Mobile-first, automatic, hybrid AI |

## Next Steps

1. **Create Flutter project** with all dependencies
2. **Set up Firebase project** (Auth, Firestore, Storage, Functions, AI Logic, Messaging)
3. **Build local database** (Drift schema + sqlite-vec)
4. **Implement Share Extension** (iOS + Android)
5. **On-device AI pipeline** (categorize → extract → embed)
6. **Hybrid router + Cloud AI** (Firebase AI Logic)
7. **RAG Chat** (local vector search + cloud synthesis)
8. **Sync Engine** (Firestore + conflict resolution)
9. **Digests & Notifications** (Cloud Functions + FCM)
10. **Polish for Demo** → Submit to Devpost