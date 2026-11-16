package com.example.lifeos

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.lifeos.app/share_extension"
    private val SHARED_PREFS_NAME = "lifeos_shared_items"
    private val SHARED_KEY = "shared_items"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPendingSharedItems" -> {
                    val items = getPendingSharedItems()
                    result.success(items)
                }
                "hasPendingSharedItems" -> {
                    result.success(hasPendingSharedItems())
                }
                "clearPendingSharedItems" -> {
                    clearPendingSharedItems()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Handle share intent when app is already running
        handleShareIntent(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Handle share intent on cold start
        handleShareIntent(intent)
    }

    private fun handleShareIntent(intent: Intent?) {
        intent?.let {
            val action = it.action
            val type = it.type

            if (Intent.ACTION_SEND == action && type != null) {
                handleSendIntent(it)
            } else if (Intent.ACTION_SEND_MULTIPLE == action && type != null) {
                handleSendMultipleIntent(it)
            }
        }
    }

    private fun handleSendIntent(intent: Intent) {
        val sharedItem = mutableMapOf<String, Any>()
        sharedItem["timestamp"] = System.currentTimeMillis()
        sharedItem["source"] = "share_extension"

        // Handle text
        intent.getStringExtra(Intent.EXTRA_TEXT)?.let { text ->
            sharedItem["text"] = text
            sharedItem["type"] = detectContentType(text)
        }

        // Handle URL
        intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let { uri ->
            sharedItem["url"] = uri.toString()
            sharedItem["type"] = when {
                uri.toString().startsWith("http") -> "link"
                uri.path?.endsWith(".pdf") == true -> "pdf"
                uri.path?.let { it.endsWith(".jpg") || it.endsWith(".jpeg") || it.endsWith(".png") } == true -> "image"
                else -> "file"
            }
        }

        // Handle subject (often used for email subjects)
        intent.getStringExtra(Intent.EXTRA_SUBJECT)?.let { subject ->
            sharedItem["subject"] = subject
        }

        saveSharedItem(sharedItem)
    }

    private fun handleSendMultipleIntent(intent: Intent) {
        val uris = intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)
        uris?.forEach { uri ->
            val sharedItem = mutableMapOf<String, Any>()
            sharedItem["timestamp"] = System.currentTimeMillis()
            sharedItem["source"] = "share_extension"
            sharedItem["url"] = uri.toString()
            sharedItem["type"] = when {
                uri.toString().startsWith("http") -> "link"
                uri.path?.endsWith(".pdf") == true -> "pdf"
                uri.path?.let { it.endsWith(".jpg") || it.endsWith(".jpeg") || it.endsWith(".png") } == true -> "image"
                else -> "file"
            }
            saveSharedItem(sharedItem)
        }
    }

    private fun detectContentType(text: String): String {
        // Detect URLs
        val urlRegex = Regex("(https?|ftp)://[^\\s/$.?#].[^\\s]*")
        if (urlRegex.containsMatchIn(text)) {
            return "link"
        }

        // Check if it looks like a task
        val taskKeywords = listOf("todo", "task", "remind", "remember", "buy", "call", "email", "schedule", "meeting", "appointment", "deadline", "due")
        val lowercased = text.lowercase()
        for (keyword in taskKeywords) {
            if (lowercased.contains(keyword)) {
                return "task"
            }
        }

        return "note"
    }

    private fun saveSharedItem(item: Map<String, Any>) {
        val sharedPrefs = getSharedPreferences(SHARED_PREFS_NAME, MODE_PRIVATE)
        val existingJson = sharedPrefs.getString(SHARED_KEY, "[]")
        
        // Parse existing items
        val gson = com.google.gson.Gson()
        val type = object : com.google.gson.reflect.TypeToken<List<Map<String, Any>>>() {}.type
        val existingItems = gson.fromJson(existingJson, type) ?: mutableListOf()
        
        // Add new item
        val updatedItems = existingItems.toMutableList()
        updatedItems.add(item)
        
        // Save back
        val newJson = gson.toJson(updatedItems)
        sharedPrefs.edit().putString(SHARED_KEY, newJson).apply()
        
        Log.d("LifeOS", "Saved shared item: $item")
    }

    private fun getPendingSharedItems(): List<Map<String, Any>> {
        val sharedPrefs = getSharedPreferences(SHARED_PREFS_NAME, MODE_PRIVATE)
        val existingJson = sharedPrefs.getString(SHARED_KEY, "[]")
        
        val gson = com.google.gson.Gson()
        val type = object : com.google.gson.reflect.TypeToken<List<Map<String, Any>>>() {}.type
        val items = gson.fromJson(existingJson, type) ?: emptyList()
        
        // Clear after reading
        clearPendingSharedItems()
        
        return items
    }

    private fun hasPendingSharedItems(): Boolean {
        val sharedPrefs = getSharedPreferences(SHARED_PREFS_NAME, MODE_PRIVATE)
        val existingJson = sharedPrefs.getString(SHARED_KEY, "[]")
        
        val gson = com.google.gson.Gson()
        val type = object : com.google.gson.reflect.TypeToken<List<Map<String, Any>>>() {}.type
        val items = gson.fromJson(existingJson, type) ?: emptyList()
        
        return items.isNotEmpty()
    }

    private fun clearPendingSharedItems() {
        val sharedPrefs = getSharedPreferences(SHARED_PREFS_NAME, MODE_PRIVATE)
        sharedPrefs.edit().remove(SHARED_KEY).apply()
    }
}
