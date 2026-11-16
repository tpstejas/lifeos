// Copyright 2024 LifeOS Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Web database connection using IndexedDB

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Open database connection for Web (IndexedDB)
QueryExecutor openConnection() => WebDatabase('lifeos_db');