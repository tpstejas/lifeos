//
//  ShareViewController.swift
//  LifeOSShareExtension
//
//  Created for LifeOS - Your Second Brain with Hybrid AI
//

import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    // App Group identifier - must match the main app's App Group
    private let appGroupIdentifier = "group.com.lifeos.app"
    private let sharedKey = "sharedItems"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set placeholder text
        textView.placeholder = "Add a note about what you're saving..."
        
        // Configure the navigation bar
        navigationItem.rightBarButtonItem?.title = "Save"
    }

    override func isContentValid() -> Bool {
        // Enable the Save button if we have content or attachments
        return !contentText.isEmpty || hasAttachments()
    }

    override func didSelectPost() {
        // Save the shared content
        saveSharedContent()
        
        // Dismiss the extension
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // No additional configuration items needed
        return []
    }

    private func hasAttachments() -> Bool {
        guard let extensionContext = extensionContext else { return false }
        for inputItem in extensionContext.inputItems as? [NSExtensionItem] ?? [] {
            if let attachments = inputItem.attachments, !attachments.isEmpty {
                return true
            }
        }
        return false
    }

    private func saveSharedContent() {
        var sharedItems: [[String: Any]] = []

        // Load existing shared items
        if let userDefaults = UserDefaults(suiteName: appGroupIdentifier),
           let existingData = userDefaults.array(forKey: sharedKey) as? [[String: Any]] {
            sharedItems = existingData
        }

        // Process the shared content
        let newItem = processSharedContent()
        if !newItem.isEmpty {
            sharedItems.append(newItem)

            // Save back to App Group
            if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
                userDefaults.set(sharedItems, forKey: sharedKey)
                userDefaults.synchronize()
            }
        }
    }

    private func processSharedContent() -> [String: Any] {
        var item: [String: Any] = [:]
        item["timestamp"] = Date().timeIntervalSince1970
        item["source"] = "share_extension"

        guard let extensionContext = extensionContext else { return item }

        for inputItem in extensionContext.inputItems as? [NSExtensionItem] ?? [] {
            // Handle text content
            if let text = contentText, !text.isEmpty {
                item["text"] = text
                item["type"] = detectContentType(text)
            }

            // Handle attachments
            if let attachments = inputItem.attachments {
                for attachment in attachments {
                    processAttachment(attachment, into: &item)
                }
            }
        }

        return item
    }

    private func detectContentType(_ text: String) -> String {
        // Detect URLs
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        if let matches = matches, !matches.isEmpty {
            return "link"
        }

        // Check if it looks like a task (contains action words)
        let taskKeywords = ["todo", "task", "remind", "remember", "buy", "call", "email", "schedule", "meeting", "appointment", "deadline", "due"]
        let lowercased = text.lowercased()
        for keyword in taskKeywords {
            if lowercased.contains(keyword) {
                return "task"
            }
        }

        return "note"
    }

    private func processAttachment(_ attachment: NSItemProvider, into item: inout [String: Any]) {
        // Handle URLs
        if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (data, error) in
                if let url = data as? URL {
                    DispatchQueue.main.async {
                        item["url"] = url.absoluteString
                        item["type"] = "link"
                        // Update the saved item
                        self?.updateSharedItem(item)
                    }
                }
            }
        }

        // Handle plain text
        if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] (data, error) in
                if let text = data as? String {
                    DispatchQueue.main.async {
                        item["text"] = text
                        if item["type"] == nil {
                            item["type"] = self?.detectContentType(text) ?? "note"
                        }
                        self?.updateSharedItem(item)
                    }
                }
            }
        }

        // Handle images
        if attachment.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            attachment.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] (data, error) in
                if let url = data as? URL {
                    DispatchQueue.main.async {
                        item["imageURL"] = url.absoluteString
                        item["type"] = "image"
                        self?.updateSharedItem(item)
                    }
                } else if let image = data as? UIImage {
                    // Save image to temporary location and store path
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        let tempDir = FileManager.default.temporaryDirectory
                        let fileName = "shared_image_\(Date().timeIntervalSince1970).jpg"
                        let fileURL = tempDir.appendingPathComponent(fileName)
                        do {
                            try imageData.write(to: fileURL)
                            DispatchQueue.main.async {
                                item["imagePath"] = fileURL.path
                                item["type"] = "image"
                                self?.updateSharedItem(item)
                            }
                        } catch {
                            print("Failed to save shared image: \(error)")
                        }
                    }
                }
            }
        }

        // Handle PDFs and other files
        if attachment.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) ||
           attachment.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
            attachment.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { [weak self] (data, error) in
                if let url = data as? URL {
                    DispatchQueue.main.async {
                        item["fileURL"] = url.absoluteString
                        item["type"] = url.pathExtension.lowercased() == "pdf" ? "pdf" : "file"
                        self?.updateSharedItem(item)
                    }
                }
            }
        }
    }

    private func updateSharedItem(_ updatedItem: [String: Any]) {
        guard let userDefaults = UserDefaults(suiteName: appGroupIdentifier),
              var sharedItems = userDefaults.array(forKey: sharedKey) as? [[String: Any]] else {
            return
        }

        // Find and update the most recent item (the one we just added)
        if let index = sharedItems.lastIndex(where: { ($0["timestamp"] as? TimeInterval) == (updatedItem["timestamp"] as? TimeInterval) }) {
            sharedItems[index] = updatedItem
        } else {
            // If not found, append
            sharedItems.append(updatedItem)
        }

        userDefaults.set(sharedItems, forKey: sharedKey)
        userDefaults.synchronize()
    }
}
