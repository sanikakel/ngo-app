import 'package:flutter/material.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  void _openSystemSettings(BuildContext context) {
    // TODO: Implement platform-specific logic to open system notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open system notification settings')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notification Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0057B8),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          ListTile(
            leading: Icon(Icons.notifications_active, color: Theme.of(context).primaryColor),
            title: Text('Enable notifications', style: TextStyle(fontWeight: FontWeight.w500)), 
            trailing: Switch(
              value: true, // TODO: Bind to actual state
              onChanged: (val) {
                // TODO: Save notification preference
              },
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
          Divider(height: 32),
          ListTile(
            leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
            title: Text('Open system notification settings'),
            onTap: () => _openSystemSettings(context),
            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
          Divider(height: 32),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: Text(
              'Manage how you receive notifications from this app.',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ),
        ],
          ),
          // DraggableTTSFab removed; global instance will be used.
        ],
      ),
    );
  }
}
