import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() { _uploading = true; _error = null; });
      final file = result.files.single;
      final ref = FirebaseStorage.instance.ref().child('resources/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
      try {
        final uploadTask = await ref.putData(file.bytes!);
        final url = await ref.getDownloadURL();
        setState(() {
          _fileUrl = url;
          _fileName = file.name;
          _uploading = false;
        });
      } catch (e) {
        setState(() { _error = 'Failed to upload file.'; _uploading = false; });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCategories.isEmpty) return;
    if (_fileUrl == null && _linkController.text.trim().isEmpty) {
      setState(() { _error = 'Please upload a file or provide a link.'; });
      return;
    }
    setState(() { _uploading = true; _error = null; });
    try {
      final docRef = await FirebaseFirestore.instance.collection('resources').add({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'categories': _selectedCategories,
        'url': _fileUrl ?? _linkController.text.trim(),
        'uploadedAt': FieldValue.serverTimestamp(),
        // TODO: Add volunteer UID if needed
      });
      // Wait for serverTimestamp to be set before closing screen
      await docRef.snapshots().firstWhere((snap) => snap.data()?['uploadedAt'] != null);
      setState(() { _uploading = false; });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() { _error = 'Failed to upload resource.'; _uploading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Resource', style: TextStyle(fontSize: widget.fontSize + 2)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[900]),
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
              Text('Upload File (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
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
              SizedBox(height: 12),
              Text('Or Paste Link (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize)),
              SizedBox(height: 6),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'https://example.com'),
                style: TextStyle(fontSize: widget.fontSize),
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
