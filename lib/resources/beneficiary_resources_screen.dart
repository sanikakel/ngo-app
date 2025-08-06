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
    return Stack(
      children: [
        Scaffold(
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
            toolbarHeight: 80, // Increased height
            titleSpacing: 20, // Increased spacing
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('resources')
                .where('categories', arrayContains: category)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error loading resources: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No resources available yet',
                        style: TextStyle(fontSize: fontSize + 2, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Check back later for helpful resources',
                        style: TextStyle(fontSize: fontSize, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }
              final resources = snapshot.data!.docs;
              // Collect all main visible text for TTS
              final ttsText = [
                'Resources',
                'Available resources for $category',
                ...resources.map((doc) => doc['title'] ?? 'Untitled resource')
              ].join('. ');
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  final doc = resources[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.description, color: Colors.blue[700]),
                      title: Text(
                        data['title'] ?? 'Untitled',
                        style: TextStyle(fontSize: fontSize + 1, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        data['description'] ?? 'No description available',
                        style: TextStyle(fontSize: fontSize),
                      ),
                      trailing: Icon(Icons.download, color: Colors.blue[700]),
                      onTap: () async {
                        final url = data['url'];
                        if (url != null && url.isNotEmpty) {
                          try {
                            final uri = Uri.parse(url);
                            
                            if (await canLaunchUrl(uri)) {
                              final result = await launchUrl(uri, mode: LaunchMode.externalApplication);
                              
                              if (!result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Could not open resource. Please try again.')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not open resource. Please check your internet connection.')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error opening resource: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No resource URL available')),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        DraggableTTSFab(
          text: 'Resources. Available resources for $category.',
          fontSize: fontSize,
          volume: 1.0,
        ),
      ],
    );
  }
}
