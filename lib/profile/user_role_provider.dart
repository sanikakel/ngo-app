import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRoleProvider {
  static Future<Map<String, String?>> getUserRoleAndCategory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'role': 'Unknown', 'category': null};
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (data == null) {
      print('[Profile Debug] No Firestore data found for user: \\${user.uid}');
      return {'role': 'Unknown', 'category': null};
    }
    print('[Profile Debug] Firestore user data: \\${data.toString()}');
    final roleRaw = data['role'] as String?;
    final role = roleRaw?.toLowerCase();
    String? accountType;
    String? category;
    if (role == 'volunteer') {
      accountType = 'Volunteer';
      category = null;
    } else if (role == 'underprivileged' || role == 'special' || role == 'senior') {
      accountType = 'Beneficiary';
      category = role;
    } else {
      print('[Profile Debug] Unknown or missing role: \\$roleRaw');
      accountType = 'Unknown';
      category = null;
    }
    return {'role': accountType, 'category': category};
  }
}

