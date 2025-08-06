import 'package:flutter/material.dart';

class ErrorHandler {
  // Convert technical errors to user-friendly messages
  static String getUserFriendlyMessage(dynamic error) {
    String errorString = error.toString().toLowerCase();
    
    // Firebase Auth Errors
    if (errorString.contains('user-not-found')) {
      return 'Account not found. Please check your email and try again.';
    } else if (errorString.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (errorString.contains('email-already-in-use')) {
      return 'An account with this email already exists. Please sign in instead.';
    } else if (errorString.contains('weak-password')) {
      return 'Password is too weak. Please choose a stronger password (at least 6 characters).';
    } else if (errorString.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (errorString.contains('too-many-requests')) {
      return 'Too many failed attempts. Please wait a moment and try again.';
    } else if (errorString.contains('network-request-failed')) {
      return 'Network connection failed. Please check your internet connection and try again.';
    }
    
    // Firebase Storage Errors
    else if (errorString.contains('storage/unauthorized')) {
      return 'You don\'t have permission to upload files. Please contact support.';
    } else if (errorString.contains('storage/quota-exceeded')) {
      return 'Storage limit reached. Please try a smaller file or contact support.';
    } else if (errorString.contains('storage/retry-limit-exceeded')) {
      return 'Upload failed due to network issues. Please try again.';
    } else if (errorString.contains('storage/invalid-checksum')) {
      return 'File upload failed. Please try again.';
    } else if (errorString.contains('storage/canceled')) {
      return 'Upload was cancelled.';
    } else if (errorString.contains('storage/object-not-found')) {
      return 'File not found. Please try uploading again.';
    } else if (errorString.contains('storage/bucket-not-found')) {
      return 'Storage service not configured. Please contact support.';
    } else if (errorString.contains('storage/project-not-found')) {
      return 'Project not found. Please contact support.';
    } else if (errorString.contains('storage/unauthorized')) {
      return 'Access denied. Please sign in again.';
    } else if (errorString.contains('storage/invalid-argument')) {
      return 'Invalid file format. Please try a different file.';
    } else if (errorString.contains('storage/unknown')) {
      return 'Upload failed due to an unknown error. Please try again.';
    }
    
    // Firestore Errors
    else if (errorString.contains('permission-denied')) {
      return 'Access denied. Please sign in again.';
    } else if (errorString.contains('unavailable')) {
      return 'Service temporarily unavailable. Please try again later.';
    } else if (errorString.contains('deadline-exceeded')) {
      return 'Request timed out. Please check your connection and try again.';
    }
    
    // File Upload Errors
    else if (errorString.contains('null check operator')) {
      return 'Unable to read the selected file. Please try a different file.';
    } else if (errorString.contains('file not found')) {
      return 'Selected file not found. Please try selecting the file again.';
    } else if (errorString.contains('permission denied')) {
      return 'Permission denied. Please allow access to your files.';
    } else if (errorString.contains('file_picker')) {
      return 'Unable to access files. Please check app permissions.';
    }
    
    // Network Errors
    else if (errorString.contains('socketexception')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('connection refused')) {
      return 'Unable to connect to server. Please try again later.';
    } else if (errorString.contains('network')) {
      return 'Network error. Please check your connection and try again.';
    }
    
    // Platform-specific errors
    else if (errorString.contains('platform')) {
      return 'Device compatibility issue. Please try again or contact support.';
    } else if (errorString.contains('ioexception')) {
      return 'File access error. Please try a different file.';
    }
    
    // General Errors
    else if (errorString.contains('null')) {
      return 'Something went wrong. Please try again.';
    } else if (errorString.contains('exception')) {
      return 'An unexpected error occurred. Please try again.';
    }
    
    // Default fallback - log the actual error for debugging
    print('DEBUG: Unhandled error type: ${error.runtimeType}');
    print('DEBUG: Unhandled error message: $errorString');
    return 'Something went wrong. Please try again.';
  }

  // Show user-friendly error snackbar
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getUserFriendlyMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Show user-friendly error dialog
  static void showErrorDialog(BuildContext context, dynamic error, {String? title}) {
    final message = getUserFriendlyMessage(error);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Handle async operations with error handling
  static Future<T?> handleAsyncOperation<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? loadingMessage,
    String? successMessage,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text(loadingMessage ?? 'Please wait...'),
                ],
              ),
            );
          },
        );
      }

      final result = await operation();

      if (showLoading) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      if (successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green[600],
            duration: Duration(seconds: 2),
          ),
        );
      }

      return result;
    } catch (error) {
      if (showLoading) {
        Navigator.of(context).pop(); // Close loading dialog
      }
      
      showErrorSnackBar(context, error);
      return null;
    }
  }

  // Check if error is network-related
  static bool isNetworkError(dynamic error) {
    String errorString = error.toString().toLowerCase();
    return errorString.contains('network') ||
           errorString.contains('socket') ||
           errorString.contains('timeout') ||
           errorString.contains('connection');
  }

  // Check if error is authentication-related
  static bool isAuthError(dynamic error) {
    String errorString = error.toString().toLowerCase();
    return errorString.contains('auth') ||
           errorString.contains('permission') ||
           errorString.contains('unauthorized');
  }
} 