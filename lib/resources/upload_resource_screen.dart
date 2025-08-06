import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io'; // Added for File
import '../utils/error_handler.dart';

class UploadResourceScreen extends StatefulWidget {
  final double fontSize;
  const UploadResourceScreen({Key? key, required this.fontSize}) : super(key: key);

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  List<String> _selectedCategories = [];
  String? _fileUrl;
  String? _fileName;
  bool _uploading = false;
  String? _error;

  final List<Map<String, String>> _categories = [
    {'label': 'Underprivileged Woman/Girl', 'value': 'underprivileged'},
    {'label': 'Specially-abled', 'value': 'special'},
    {'label': 'Senior Citizen', 'value': 'senior'},
  ];

  // Test Firebase Storage connection
  Future<bool> _testFirebaseStorage() async {
    try {
      print('DEBUG: Testing Firebase Storage connection...');
      final testRef = FirebaseStorage.instance.ref().child('test/connection_test.txt');
      await testRef.putString('test');
      await testRef.delete();
      print('DEBUG: Firebase Storage connection test successful');
      return true;
    } catch (e) {
      print('DEBUG: Firebase Storage connection test failed: $e');
      return false;
    }
  }

  Future<void> _pickFile() async {
    try {
      print('DEBUG: Starting file picker...');
      
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Please sign in to upload files.';
        });
        return;
      }
      print('DEBUG: User authenticated: ${user.uid}');
      
      // Test Firebase Storage connection first
      final storageWorking = await _testFirebaseStorage();
      if (!storageWorking) {
        setState(() {
          _error = 'Storage service not available. Please try again later.';
        });
        return;
      }
      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      
      print('DEBUG: File picker result: ${result?.files.length ?? 0} files');
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('DEBUG: Selected file - Name: ${file.name}, Size: ${file.size}, Path: ${file.path}, Has bytes: ${file.bytes != null}');
        
        // Validate file size (max 10MB)
        if (file.size > 10 * 1024 * 1024) {
          setState(() { 
            _error = 'File size too large. Please select a file smaller than 10MB.'; 
          });
          return;
        }
        
        // Check if file has a path (for local files) or bytes (for web)
        if (file.path != null && file.path!.isNotEmpty) {
          print('DEBUG: Using file path for upload: ${file.path}');
          // Handle local file upload
          setState(() { _uploading = true; _error = null; });
          final fileRef = FirebaseStorage.instance.ref().child('resources/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
          try {
            print('DEBUG: Starting file upload to Firebase Storage...');
            await fileRef.putFile(File(file.path!));
            print('DEBUG: File upload completed, getting download URL...');
            final url = await fileRef.getDownloadURL();
            print('DEBUG: Download URL obtained: $url');
            setState(() {
              _fileUrl = url;
              _fileName = file.name;
              _uploading = false;
            });
            print('DEBUG: File upload successful!');
          } catch (e) {
            print('DEBUG: File upload error: $e');
            print('DEBUG: Error type: ${e.runtimeType}');
            setState(() { 
              _error = ErrorHandler.getUserFriendlyMessage(e); 
              _uploading = false; 
            });
          }
        } else if (file.bytes != null && file.bytes!.isNotEmpty) {
          print('DEBUG: Using file bytes for upload, bytes length: ${file.bytes!.length}');
          // Handle web file upload
          setState(() { _uploading = true; _error = null; });
          final fileRef = FirebaseStorage.instance.ref().child('resources/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
          try {
            print('DEBUG: Starting bytes upload to Firebase Storage...');
            await fileRef.putData(file.bytes!);
            print('DEBUG: Bytes upload completed, getting download URL...');
            final url = await fileRef.getDownloadURL();
            print('DEBUG: Download URL obtained: $url');
            setState(() {
              _fileUrl = url;
              _fileName = file.name;
              _uploading = false;
            });
            print('DEBUG: Bytes upload successful!');
          } catch (e) {
            print('DEBUG: Bytes upload error: $e');
            print('DEBUG: Error type: ${e.runtimeType}');
            setState(() { 
              _error = ErrorHandler.getUserFriendlyMessage(e); 
              _uploading = false; 
            });
          }
        } else {
          print('DEBUG: No valid file data found - path: ${file.path}, bytes: ${file.bytes?.length ?? 0}');
          setState(() { 
            _error = 'Failed to read file data. Please try again.'; 
          });
        }
      } else {
        print('DEBUG: No file selected or result is null');
      }
    } catch (e) {
      print('DEBUG: File picker error: $e');
      print('DEBUG: Error type: ${e.runtimeType}');
      setState(() { 
        _error = ErrorHandler.getUserFriendlyMessage(e); 
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCategories.isEmpty) {
      setState(() { 
        _error = 'Please fill all required fields and select at least one category.'; 
      });
      return;
    }
    
    if (_fileUrl == null && _linkController.text.trim().isEmpty) {
      setState(() { _error = 'Please upload a file or provide a link.'; });
      return;
    }
    
    setState(() { _uploading = true; _error = null; });
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() { 
          _error = 'User not authenticated. Please sign in again.'; 
          _uploading = false; 
        });
        return;
      }
      
      final docRef = await FirebaseFirestore.instance.collection('resources').add({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'categories': _selectedCategories,
        'url': _fileUrl ?? _linkController.text.trim(),
        'uploadedAt': FieldValue.serverTimestamp(),
        'uploadedBy': user.uid,
        'uploadedByRole': 'volunteer',
      });
      
      // Wait for serverTimestamp to be set before closing screen
      await docRef.snapshots().firstWhere((snap) => snap.data()?['uploadedAt'] != null);
      setState(() { _uploading = false; });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resource uploaded successfully!', style: TextStyle(fontSize: widget.fontSize)),
            backgroundColor: Colors.green[600],
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Upload error: $e');
      setState(() { 
        _error = ErrorHandler.getUserFriendlyMessage(e); 
        _uploading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Resource', style: TextStyle(fontSize: widget.fontSize + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0057B8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: Color(0xFF0057B8)),
        toolbarHeight: 80, // Increased height
        titleSpacing: 20, // Increased spacing
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
              SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                validator: (v) => v!.trim().isEmpty ? 'Enter a title' : null,
                decoration: InputDecoration(border: OutlineInputBorder()),
                style: TextStyle(fontSize: widget.fontSize),
              ),
              SizedBox(height: 16),
              Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
              SizedBox(height: 6),
              TextFormField(
                controller: _descController,
                validator: (v) => v!.trim().isEmpty ? 'Enter a description' : null,
                maxLines: 3,
                decoration: InputDecoration(border: OutlineInputBorder()),
                style: TextStyle(fontSize: widget.fontSize),
              ),
              SizedBox(height: 16),
              Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
              SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _categories.map((cat) => FilterChip(
                  label: Text(cat['label']!, style: TextStyle(fontSize: widget.fontSize - 2)),
                  selected: _selectedCategories.contains(cat['value']!),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(cat['value']!);
                      } else {
                        _selectedCategories.remove(cat['value']!);
                      }
                    });
                  },
                )).toList(),
              ),
              SizedBox(height: 16),
              Text('Paste Link', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
              SizedBox(height: 6),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'https://example.com'),
                style: TextStyle(fontSize: widget.fontSize),
              ),
              SizedBox(height: 16),
              Text('Upload File (not yet available)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
              SizedBox(height: 6),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.attach_file),
                    label: Text(_fileUrl != null ? 'File Uploaded' : 'Choose File', style: TextStyle(fontSize: widget.fontSize - 2)),
                    onPressed: _uploading ? null : _pickFile,
                  ),
                  if (_fileName != null) ...[
                    SizedBox(width: 8),
                    Flexible(child: Text(_fileName!, style: TextStyle(fontSize: widget.fontSize - 2))),
                  ]
                ],
              ),
              SizedBox(height: 24),
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: Colors.red, fontSize: widget.fontSize)),
                SizedBox(height: 8),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _uploading
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Upload Resource', style: TextStyle(fontSize: widget.fontSize, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
