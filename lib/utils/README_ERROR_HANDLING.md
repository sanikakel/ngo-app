# Error Handling System

This app uses a centralized error handling system to provide user-friendly error messages instead of technical jargon.

## How to Use

### 1. Basic Error Handling

```dart
import '../utils/error_handler.dart';

try {
  // Your code here
} catch (e) {
  // Show user-friendly error message
  ErrorHandler.showErrorSnackBar(context, e);
}
```

### 2. Get User-Friendly Error Message

```dart
String userMessage = ErrorHandler.getUserFriendlyMessage(error);
setState(() {
  _error = userMessage;
});
```

### 3. Show Error Dialog

```dart
ErrorHandler.showErrorDialog(context, error, title: 'Upload Failed');
```

### 4. Handle Async Operations

```dart
final result = await ErrorHandler.handleAsyncOperation(
  context,
  () async {
    // Your async operation here
    return await someAsyncFunction();
  },
  loadingMessage: 'Uploading file...',
  successMessage: 'File uploaded successfully!',
);
```

## Supported Error Types

### Firebase Auth Errors
- `user-not-found` → "Account not found. Please check your email and try again."
- `wrong-password` → "Incorrect password. Please try again."
- `email-already-in-use` → "An account with this email already exists. Please sign in instead."
- `weak-password` → "Password is too weak. Please choose a stronger password (at least 6 characters)."
- `invalid-email` → "Please enter a valid email address."
- `too-many-requests` → "Too many failed attempts. Please wait a moment and try again."
- `network-request-failed` → "Network connection failed. Please check your internet connection and try again."

### Firebase Storage Errors
- `storage/unauthorized` → "You don't have permission to upload files. Please contact support."
- `storage/quota-exceeded` → "Storage limit reached. Please try a smaller file or contact support."
- `storage/retry-limit-exceeded` → "Upload failed due to network issues. Please try again."
- `storage/invalid-checksum` → "File upload failed. Please try again."
- `storage/canceled` → "Upload was cancelled."

### Firestore Errors
- `permission-denied` → "Access denied. Please sign in again."
- `unavailable` → "Service temporarily unavailable. Please try again later."
- `deadline-exceeded` → "Request timed out. Please check your connection and try again."

### File Upload Errors
- `null check operator` → "Unable to read the selected file. Please try a different file."
- `file not found` → "Selected file not found. Please try selecting the file again."
- `permission denied` → "Permission denied. Please allow access to your files."

### Network Errors
- `socketexception` → "No internet connection. Please check your network and try again."
- `timeout` → "Request timed out. Please try again."
- `connection refused` → "Unable to connect to server. Please try again later."

## Best Practices

1. **Always wrap async operations in try-catch blocks**
2. **Use ErrorHandler.showErrorSnackBar() for user-facing errors**
3. **Use ErrorHandler.getUserFriendlyMessage() for custom error displays**
4. **Log technical errors for debugging but show user-friendly messages**
5. **Provide specific guidance when possible (e.g., "Please try a smaller file")**

## Example Implementation

```dart
Future<void> uploadFile() async {
  try {
    setState(() { _uploading = true; });
    
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    
    final file = result.files.first;
    final ref = FirebaseStorage.instance.ref().child('files/${file.name}');
    
    await ref.putData(file.bytes!);
    final url = await ref.getDownloadURL();
    
    setState(() { 
      _fileUrl = url;
      _uploading = false; 
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File uploaded successfully!'),
        backgroundColor: Colors.green[600],
      ),
    );
    
  } catch (e) {
    setState(() { _uploading = false; });
    ErrorHandler.showErrorSnackBar(context, e);
  }
}
```

This ensures users always see helpful, actionable error messages instead of technical error codes. 