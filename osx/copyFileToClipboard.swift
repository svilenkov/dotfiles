import Cocoa

// Get the file path from command-line arguments
guard CommandLine.arguments.count == 2 else {
    print("Usage: \(CommandLine.arguments[0]) <file_path>")
    exit(1)
}

let filePath = CommandLine.arguments[1]

// Verify the file exists
guard FileManager.default.fileExists(atPath: filePath) else {
    print("Error: File '\(filePath)' does not exist.")
    exit(1)
}

// Create a file URL
guard let fileURL = URL(string: "file://\(filePath)") else {
    print("Error: Invalid file path.")
    exit(1)
}

// Set the file URL on the clipboard
let pasteboard = NSPasteboard.general
pasteboard.clearContents()
pasteboard.writeObjects([fileURL as NSPasteboardWriting])

// Notify user
let notification = NSUserNotification()
notification.title = "Success"
notification.informativeText = "File copied to clipboard!"
NSUserNotificationCenter.default.deliver(notification)

exit(0)
