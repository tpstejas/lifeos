// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Conditional export for platform-specific database connection function
// Native (iOS, Android, macOS, Windows, Linux): uses sqlite3 via dart:ffi
// Web: uses IndexedDB via package:drift/web.dart

export 'app_database_connection.dart'
    if (dart.library.js) 'app_database_connection_web.dart';