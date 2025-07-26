import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../accessibility/font_size_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_role_provider.dart';

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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserRoleAndName();
  }

  Future<void> _fetchUserRoleAndName() async {
    final user = FirebaseAuth.instance.currentUser;
    final result = await UserRoleProvider.getUserRoleAndCategory();
    String? fetchedName;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        fetchedName = userDoc.data()?['name'];
      } catch (_) {}
    }
    setState(() {
      accountType = result['role'];
      category = result['category'];
      firestoreName = fetchedName;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final double fontSize = widget.fontSizeNotifier.value;

    String displayName = firestoreName ?? user?.displayName ?? 'No Name';

    String accountTypeLabel = accountType ?? 'Unknown';
    String categoryLabel = '';
    if (accountType == 'Beneficiary') {
      switch (category) {
        case 'underprivileged':
          categoryLabel = 'Underprivileged';
          break;
        case 'special':
          categoryLabel = 'Specially-Abled';
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
          title: Text('Profile', style: TextStyle(fontSize: fontSize + 4)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontSize: fontSize + 4)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.account_circle, size: 48, color: Colors.blueGrey),
                ),
                SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize + 4)),
                    SizedBox(height: 4),
                    Text(user?.email ?? 'No Email', style: TextStyle(fontSize: fontSize + 1, color: Colors.grey.shade700)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 28),
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
            // Add more profile features here as needed
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text('Sign Out', style: TextStyle(fontSize: fontSize + 1)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
