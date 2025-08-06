import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/draggable_tts_fab.dart';
import '../accessibility/font_size_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_role_provider.dart';
import '../auth/auth_wrapper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../utils/error_handler.dart';

class ProfileScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  const ProfileScreen({super.key, required this.fontSizeNotifier});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? accountType;
  String? category;
  String? firestoreName;
  String? firestorePhone;
  String? firestoreAge;
  String? profilePicUrl;
  bool loading = true;
  bool isEditing = false;

  Future<void> pickAndUploadProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
      if (pickedFile == null) return;
      
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ErrorHandler.showErrorSnackBar(context, 'User not authenticated. Please sign in again.');
        return;
      }
      
      // Check if the picked file has a valid path
      if (pickedFile.path == null || pickedFile.path!.isEmpty) {
        ErrorHandler.showErrorSnackBar(context, 'Failed to read image file. Please try again.');
        return;
      }
      
      final file = File(pickedFile.path!);
      
      // Check if file exists
      if (!await file.exists()) {
        ErrorHandler.showErrorSnackBar(context, 'Selected file does not exist. Please try again.');
        return;
      }
      
      final storageRef = FirebaseStorage.instance.ref().child('profile_pics/${user.uid}.jpg');
      
      try {
        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();
        await user.updatePhotoURL(downloadUrl);
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'photoURL': downloadUrl}, SetOptions(merge: true));
        setState(() {
          profilePicUrl = downloadUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated!'),
            backgroundColor: Colors.green[600],
          ),
        );
      } catch (e) {
        print('Upload error: $e');
        ErrorHandler.showErrorSnackBar(context, e);
      }
    } catch (e) {
      print('Image picker error: $e');
      ErrorHandler.showErrorSnackBar(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserRoleAndName();
  }

  Future<void> _fetchUserRoleAndName() async {
    final user = FirebaseAuth.instance.currentUser;
    final result = await UserRoleProvider.getUserRoleAndCategory();
    String? fetchedName;
    String? fetchedPhone;
    String? fetchedAge;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final data = userDoc.data();
        fetchedName = data?['name'];
        fetchedPhone = data?['phone'];
        fetchedAge = data?['age'];
        final photoUrlStr = data?['photoURL']?.toString() ?? '';
        if (photoUrlStr.isNotEmpty) {
          profilePicUrl = photoUrlStr;
        } else if (user.photoURL != null && user.photoURL!.isNotEmpty) {
          profilePicUrl = user.photoURL;
        }
      } catch (_) {}
    }
    setState(() {
      accountType = result['role'];
      category = result['category'];
      firestoreName = fetchedName;
      firestorePhone = fetchedPhone;
      firestoreAge = fetchedAge;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final double fontSize = widget.fontSizeNotifier.value;

    String displayName = firestoreName ?? user?.displayName ?? 'No name';

    String accountTypeLabel = accountType != null
        ? (accountType == 'Beneficiary'
            ? 'Beneficiary'
            : accountType == 'Volunteer'
                ? 'Volunteer'
                : 'Unknown')
        : 'Unknown';
    String categoryLabel = '';
    if (accountType == 'Beneficiary') {
      switch (category) {
        case 'underprivileged':
          categoryLabel = 'Underprivileged';
          break;
        case 'special':
          categoryLabel = 'Specially-abled';
          break;
        case 'senior':
          categoryLabel = 'Senior Citizen';
          break;
        default:
          categoryLabel = 'Beneficiary';
      }
    } else if (accountType == 'Volunteer') {
      categoryLabel = 'Volunteer';
    }

    if (loading) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: fontSize + 6,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0057B8),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Move isEditing to State
    final TextEditingController nameController = TextEditingController(text: displayName);
    final TextEditingController emailController = TextEditingController(text: user?.email ?? '');
    final TextEditingController phoneController = TextEditingController(text: firestorePhone ?? '');
    final TextEditingController ageController = TextEditingController(text: firestoreAge ?? '');
    String? profilePicUrl;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Profile', style: TextStyle(fontSize: fontSize + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0057B8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 80, // Increased height
        titleSpacing: 20, // Increased spacing
      ),
      floatingActionButton: DraggableTTSFab(
        text: 'Profile screen. View and edit your details.',
        fontSize: fontSize,
        volume: 1.0,
      ),
      body: Container(
        color: Color(0xFFF6F8FB),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: (profilePicUrl != null && profilePicUrl!.isNotEmpty) ? NetworkImage(profilePicUrl!) : null,
                    child: (profilePicUrl == null || profilePicUrl!.isEmpty) ? Icon(Icons.account_circle, size: 64, color: Colors.blueGrey) : null,
                  ),
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: pickAndUploadProfileImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt, color: Colors.blue[900]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Profile Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0057B8)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    if (isEditing) ...[
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: ageController,
                        decoration: InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0057B8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              setState(() { loading = true; });
                              final user = FirebaseAuth.instance.currentUser;
                              try {
                                if (user != null) {
                                  // Update Firestore
                                  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                                    'name': nameController.text.trim(),
                                    'email': emailController.text.trim(),
                                    'phone': phoneController.text.trim(),
                                    'age': ageController.text.trim(),
                                  }, SetOptions(merge: true));
                                  // Update FirebaseAuth displayName/email
                                  await user.updateDisplayName(nameController.text.trim());
                                  if (user.email != emailController.text.trim()) {
                                    await user.verifyBeforeUpdateEmail(emailController.text.trim());
                                  }
                                }
                                setState(() {
                                  firestoreName = nameController.text.trim();
                                  firestorePhone = phoneController.text.trim();
                                  firestoreAge = ageController.text.trim();
                                  isEditing = false;
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Profile updated successfully.')),
                                );
                              } catch (e) {
                                setState(() { loading = false; });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to update profile: ' + e.toString())),
                                );
                              }
                            },
                            child: Text('Save'),
                          ),
                          SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                              });
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    ] else ...[
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Name', style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                        subtitle: Text(displayName, style: TextStyle(fontSize: widget.fontSizeNotifier.value + 2, fontWeight: FontWeight.w500)),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Email', style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                        subtitle: Text(user?.email ?? 'Unknown', style: TextStyle(fontSize: widget.fontSizeNotifier.value + 1)),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone Number', style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                        subtitle: Text((firestorePhone != null && firestorePhone!.isNotEmpty) ? firestorePhone! : 'Not set', style: TextStyle(fontSize: widget.fontSizeNotifier.value + 1)),
                      ),
                      ListTile(
                        leading: Icon(Icons.cake),
                        title: Text('Age', style: TextStyle(fontSize: widget.fontSizeNotifier.value)),
                        subtitle: Text((firestoreAge != null && firestoreAge!.isNotEmpty) ? firestoreAge! : 'Not set', style: TextStyle(fontSize: widget.fontSizeNotifier.value + 1)),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.edit),
                            label: Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0057B8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            Divider(),
            SizedBox(height: 18),
            Text('Account Type:', style: TextStyle(fontSize: fontSize + 1, color: Colors.grey.shade800)),
            SizedBox(height: 4),
            Text(accountTypeLabel, style: TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize + 2)),
            if (categoryLabel.isNotEmpty && accountType == 'Beneficiary') ...[
              SizedBox(height: 12),
              Text('Beneficiary Category:', style: TextStyle(fontSize: fontSize + 1, color: Colors.grey.shade800)),
              SizedBox(height: 4),
              Text(categoryLabel, style: TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize + 2)),
            ],
            SizedBox(height: 28),
            Divider(),
            SizedBox(height: 18),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text('Sign Out', style: TextStyle(fontSize: fontSize + 1)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => AuthWrapper(fontSizeNotifier: widget.fontSizeNotifier)),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
