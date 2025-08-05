import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../profile/user_role_provider.dart';
import '../home/volunteer_home.dart';
import '../home/beneficiary_home.dart';
import '../accessibility/font_size_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/draggable_tts_fab.dart';

class BeneficiaryResourcesScreen extends StatelessWidget {
  final String category;
  final double fontSize;
  const BeneficiaryResourcesScreen({Key? key, required this.category, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[900]),
          onPressed: () async {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // If cannot pop, go to home screen based on user role
              final roleData = await UserRoleProvider.getUserRoleAndCategory();
              final role = roleData['role'];
              final category = roleData['category'];
              final fontSizeNotifier = context.read<FontSizeNotifier?>() ?? FontSizeNotifier(16.0);
              if (role == 'Volunteer') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => VolunteerHome(fontSizeNotifier: fontSizeNotifier)),
                  (route) => false,
                );
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => BeneficiaryHome(category: category ?? '', fontSizeNotifier: fontSizeNotifier)),
                  (route) => false,
                );
              }
            }
          },
        ),
        title: Text('Resources', style: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.bold, color: Colors.blue[900])),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.blue[900]),
        shadowColor: Colors.blue[50],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('resources')
            .where('categories', arrayContains: category)
            .orderBy('uploadedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            print('Fetched resources:');
            for (var d in snapshot.data!.docs) {
              print(d.data());
            }
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No resources available yet.', style: TextStyle(fontSize: fontSize)));
          }
          final docs = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            itemCount: docs.length,
            separatorBuilder: (_, __) => SizedBox(height: 18),
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final title = data['title'] ?? '';
              final desc = data['description'] ?? '';
              final url = data['url'] ?? '';
              final uploadedAt = (data['uploadedAt'] as Timestamp?)?.toDate();
              IconData icon;
              Color iconColor;
              if (url.toString().contains('.pdf')) {
                icon = Icons.picture_as_pdf;
                iconColor = Colors.red[400]!;
              } else if (url.toString().contains('.jpg') || url.toString().contains('.jpeg') || url.toString().contains('.png')) {
                icon = Icons.image;
                iconColor = Colors.green[400]!;
              } else {
                icon = Icons.link;
                iconColor = Colors.blue[700]!;
              }
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[50]!,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(icon, color: iconColor, size: fontSize + 10),
                  ),
                  title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize + 2, color: Colors.blue[900])),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (desc.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                          child: Text(desc, style: TextStyle(fontSize: fontSize - 1, color: Colors.grey[800])),
                        ),
                      if (uploadedAt != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text('Uploaded:  ${uploadedAt.day}/${uploadedAt.month}/${uploadedAt.year}', style: TextStyle(fontSize: fontSize - 4, color: Colors.grey[600])),
                        ),
                    ],
                  ),
                  trailing: Icon(Icons.open_in_new, color: Colors.blue[400], size: fontSize + 4),
                  onTap: () async {
                    if (url.toString().startsWith('http')) {
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
