# File Upload Troubleshooting Guide

## Issue: "Something went wrong. Please try again." when uploading files

### Possible Causes and Solutions:

#### 1. Firebase Storage Not Configured
**Problem**: Firebase Storage might not be enabled in your Firebase project.

**Solution**: 
1. Go to Firebase Console > Storage
2. Click "Get Started" if Storage is not enabled
3. Choose a location for your storage bucket
4. Start in test mode (allow all reads/writes) for development

#### 2. Firebase Storage Rules Too Restrictive
**Problem**: Storage rules might be blocking uploads.

**Solution**: 
1. Go to Firebase Console > Storage > Rules
2. Replace the rules with the ones in `firebase_storage_rules.txt`
3. Or temporarily use test mode rules:
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

#### 3. Network Connectivity Issues
**Problem**: Poor internet connection or firewall blocking uploads.

**Solution**:
- Check your internet connection
- Try uploading a smaller file first
- Check if you're on a restricted network

#### 4. File Size Too Large
**Problem**: File exceeds the 10MB limit.

**Solution**:
- Compress the image or use a smaller file
- Try uploading a different file type

#### 5. File Permissions
**Problem**: App doesn't have permission to access files.

**Solution**:
- Grant storage permissions to the app
- Try selecting the file from a different location

#### 6. Firebase Project Configuration
**Problem**: Wrong Firebase project or configuration.

**Solution**:
- Verify `google-services.json` is from the correct Firebase project
- Check that the project has Storage enabled
- Ensure the app is properly registered in Firebase

### Debug Steps:

1. **Check Console Logs**: Look for DEBUG messages in the console
2. **Test with Different Files**: Try uploading different file types and sizes
3. **Check Firebase Console**: Look for any error messages in Firebase Console > Storage
4. **Verify Authentication**: Ensure you're signed in before uploading

### Quick Test:

Try uploading a simple text file first to test the basic functionality. If that works, the issue might be with specific file types or sizes.

### Contact Support:

If the issue persists, please provide:
- The exact error message from console logs
- File type and size you're trying to upload
- Your device/OS information
- Screenshot of any error messages 