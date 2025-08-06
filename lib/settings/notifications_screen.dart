import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/draggable_tts_fab.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _notificationsEnabled = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    setState(() {
      _loading = true;
    });
    
    try {
      // Check notification permission status
      final status = await Permission.notification.status;
      setState(() {
        _notificationsEnabled = status.isGranted;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _notificationsEnabled = false;
        _loading = false;
      });
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      // Request notification permission
      final status = await Permission.notification.request();
      setState(() {
        _notificationsEnabled = status.isGranted;
      });
      
      if (status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notifications enabled'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification permission denied. Please enable in settings.'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: _openSystemSettings,
            ),
          ),
        );
      }
    } else {
      // Show message that user needs to disable in system settings
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please disable notifications in your device settings'),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: _openSystemSettings,
          ),
        ),
      );
    }
  }

  Future<void> _openSystemSettings() async {
    try {
      if (Platform.isAndroid) {
        // Open Android notification settings
        const platform = MethodChannel('notification_settings');
        await platform.invokeMethod('openNotificationSettings');
      } else if (Platform.isIOS) {
        // Open iOS notification settings
        const platform = MethodChannel('notification_settings');
        await platform.invokeMethod('openNotificationSettings');
      } else {
        // Fallback for other platforms
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please open your device settings to manage notifications'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Fallback if platform-specific method fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please go to your device settings > Apps > Yes I Can > Notifications'),
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontSize: 22 + 2, color: const Color(0xFF0057B8), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF0057B8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 80, // Increased height
        titleSpacing: 20, // Increased spacing
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              if (_loading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                ListTile(
                  leading: Icon(Icons.notifications_active, color: Theme.of(context).primaryColor),
                  title: Text('Enable notifications', style: TextStyle(fontWeight: FontWeight.w500)), 
                  subtitle: Text('Receive important updates and messages'),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                ),
                Divider(height: 32),
                ListTile(
                  leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
                  title: Text('System notification settings'),
                  subtitle: Text('Manage notification permissions'),
                  onTap: _openSystemSettings,
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                ),
                Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notification Types',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildNotificationType('Chat messages', 'Get notified when someone sends you a message', true),
                          _buildNotificationType('Resource updates', 'New resources and materials available', true),
                          _buildNotificationType('App updates', 'Important app updates and announcements', false),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Text(
                    'Manage how you receive notifications from this app. You can also control notifications through your device settings.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
          DraggableTTSFab(
            text: 'Notifications screen. Enable notifications. System notification settings. Manage how you receive notifications from this app.',
            fontSize: 16.0,
            volume: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationType(String title, String description, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (value) {
              // Handle individual notification type toggles
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title ${value ? 'enabled' : 'disabled'}'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
