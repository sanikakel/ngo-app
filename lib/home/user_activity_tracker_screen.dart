import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../accessibility/font_size_provider.dart';
import '../widgets/draggable_tts_fab.dart';
import '../home/volunteer_home.dart'; // Added import for VolunteerHome

class UserActivityTrackerScreen extends StatefulWidget {
  final FontSizeNotifier fontSizeNotifier;
  const UserActivityTrackerScreen({required this.fontSizeNotifier, super.key});

  @override
  State<UserActivityTrackerScreen> createState() => _UserActivityTrackerScreenState();
}

class _UserActivityTrackerScreenState extends State<UserActivityTrackerScreen> {
  List<UserActivityData> _userActivities = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadUserActivities();
  }

  Future<void> _loadUserActivities() async {
    setState(() => _isLoading = true);
    
    try {
      // Get all users from Firestore
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      final now = DateTime.now();
      
      List<UserActivityData> activities = [];
      
      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        final lastLoginTimestamp = userData['lastLoginTimestamp'] as Timestamp?;
        final lastActivityTimestamp = userData['lastActivityTimestamp'] as Timestamp?;
        final role = userData['role'] as String? ?? 'beneficiary';
        final name = userData['name'] as String? ?? 'Unknown User';
        final category = userData['category'] as String? ?? role; // Use role as fallback for category
        final createdAt = userData['createdAt'] as Timestamp?;
        
        // Skip volunteers, only track beneficiaries
        if (role == 'volunteer') continue;
        
        DateTime? lastLogin;
        DateTime? lastActivity;
        DateTime? createdDate;
        
        if (lastLoginTimestamp != null) {
          lastLogin = lastLoginTimestamp.toDate();
        }
        if (lastActivityTimestamp != null) {
          lastActivity = lastActivityTimestamp.toDate();
        }
        if (createdAt != null) {
          createdDate = createdAt.toDate();
        }
        
        // Determine user status based on enhanced criteria
        String status = _determineUserStatus(now, lastLogin, lastActivity, createdDate);
        String riskReason = _getRiskReason(now, lastLogin, lastActivity, createdDate);
        
        // Format category for display
        String displayCategory = _formatCategory(category);
        
        activities.add(UserActivityData(
          userId: userDoc.id,
          name: name,
          category: displayCategory,
          lastLogin: lastLogin,
          lastActivity: lastActivity,
          status: status,
          riskReason: riskReason,
        ));
      }
      
      // Sort by status priority: At Risk > Inactive > Active
      activities.sort((a, b) {
        final statusPriority = {'At Risk': 3, 'Inactive': 2, 'Active': 1};
        return statusPriority[b.status]!.compareTo(statusPriority[a.status]!);
      });
      
      setState(() {
        _userActivities = activities;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user activities: $e');
      setState(() => _isLoading = false);
    }
  }

  String _determineUserStatus(DateTime now, DateTime? lastLogin, DateTime? lastActivity, DateTime? createdDate) {
    // Enhanced criteria for "At Risk" classification
    if (_isAtRisk(now, lastLogin, lastActivity, createdDate)) {
      return 'At Risk';
    }
    
    // Use the most recent activity (login or other activity)
    DateTime? mostRecentActivity = lastActivity ?? lastLogin;
    if (mostRecentActivity == null) {
      return 'Inactive'; // No activity recorded
    }
    
    final daysSinceActivity = now.difference(mostRecentActivity).inDays;
    
    if (daysSinceActivity <= 3) {
      return 'Active';
    } else {
      return 'Inactive';
    }
  }

  bool _isAtRisk(DateTime now, DateTime? lastLogin, DateTime? lastActivity, DateTime? createdDate) {
    // Criteria 1: No login for 10+ days
    if (lastLogin != null) {
      final daysSinceLogin = now.difference(lastLogin).inDays;
      if (daysSinceLogin >= 10) return true;
    }
    
    // Criteria 2: No activity for 10+ days
    DateTime? mostRecentActivity = lastActivity ?? lastLogin;
    if (mostRecentActivity != null) {
      final daysSinceActivity = now.difference(mostRecentActivity).inDays;
      if (daysSinceActivity >= 10) return true;
    }
    
    // Criteria 3: Registered but never logged in (created more than 7 days ago)
    if (createdDate != null && lastLogin == null) {
      final daysSinceCreation = now.difference(createdDate).inDays;
      if (daysSinceCreation >= 7) return true;
    }
    
    return false;
  }

  String _getRiskReason(DateTime now, DateTime? lastLogin, DateTime? lastActivity, DateTime? createdDate) {
    List<String> reasons = [];
    
    // Check each criteria and add reason
    if (lastLogin != null) {
      final daysSinceLogin = now.difference(lastLogin).inDays;
      if (daysSinceLogin >= 10) {
        reasons.add('No login for ${daysSinceLogin} days');
      }
    }
    
    DateTime? mostRecentActivity = lastActivity ?? lastLogin;
    if (mostRecentActivity != null) {
      final daysSinceActivity = now.difference(mostRecentActivity).inDays;
      if (daysSinceActivity >= 10) {
        reasons.add('No activity for ${daysSinceActivity} days');
      }
    }
    
    if (createdDate != null && lastLogin == null) {
      final daysSinceCreation = now.difference(createdDate).inDays;
      if (daysSinceCreation >= 7) {
        reasons.add('Registered ${daysSinceCreation} days ago but never logged in');
      }
    }
    
    return reasons.join(', ');
  }

  String _formatCategory(String category) {
    if (category.isEmpty) {
      return 'No category';
    }
    
    // Format the category for display
    switch (category.toLowerCase()) {
      case 'underprivileged':
        return 'Underprivileged Woman/Girl';
      case 'senior':
        return 'Senior Citizen';
      case 'special':
        return 'Specially-abled';
      case 'volunteer':
        return 'Volunteer';
      default:
        // Capitalize first letter and replace underscores with spaces
        return category.split('_').map((word) => 
          word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : ''
        ).join(' ');
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Color(0xFF4CAF50); // Green
      case 'Inactive':
        return Color(0xFFFF9800); // Orange
      case 'At Risk':
        return Color(0xFFF44336); // Red
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Active':
        return Icons.check_circle;
      case 'Inactive':
        return Icons.warning;
      case 'At Risk':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  List<UserActivityData> get _filteredActivities {
    if (_selectedFilter == 'All') {
      return _userActivities;
    }
    return _userActivities.where((user) => user.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.fontSizeNotifier.value;
    
    // Collect all main visible text for TTS
    final ttsText = [
      'User Activity Tracker',
      'Track beneficiary activity and engagement',
      'Active users: ${_userActivities.where((u) => u.status == 'Active').length}',
      'Inactive users: ${_userActivities.where((u) => u.status == 'Inactive').length}',
      'At risk users: ${_userActivities.where((u) => u.status == 'At Risk').length}',
    ].join('. ');
    
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xFFF7FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('Activity Tracker', style: TextStyle(fontSize: fontSize + 2, color: Color(0xFF0057B8), fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF0057B8)),
              onPressed: () {
                // Navigate back to volunteer home screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => VolunteerHome(fontSizeNotifier: widget.fontSizeNotifier),
                  ),
                  (route) => false,
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: Color(0xFF0057B8)),
                onPressed: _loadUserActivities,
                tooltip: 'Refresh',
              ),
            ],
            toolbarHeight: 80, // Increased height
            titleSpacing: 20, // Increased spacing
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Summary Cards
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Active',
                          count: _userActivities.where((u) => u.status == 'Active').length,
                          color: Color(0xFF4CAF50),
                          icon: Icons.check_circle,
                          fontSize: fontSize,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Inactive',
                          count: _userActivities.where((u) => u.status == 'Inactive').length,
                          color: Color(0xFFFF9800),
                          icon: Icons.warning,
                          fontSize: fontSize,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'At Risk',
                          count: _userActivities.where((u) => u.status == 'At Risk').length,
                          color: Color(0xFFF44336),
                          icon: Icons.error,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Filter Buttons
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Filter: ', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Active', 'Inactive', 'At Risk'].map((filter) => 
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(filter, style: TextStyle(fontSize: fontSize - 1)),
                                selected: _selectedFilter == filter,
                                onSelected: (selected) {
                                  setState(() => _selectedFilter = filter);
                                },
                                backgroundColor: Colors.grey[200],
                                selectedColor: Color(0xFF0057B8),
                                labelStyle: TextStyle(
                                  color: _selectedFilter == filter ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // At Risk Criteria Info (only when At Risk filter is selected)
                if (_selectedFilter == 'At Risk')
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF44336).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFF44336).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFFF44336), size: fontSize + 4),
                            SizedBox(width: 8),
                            Text(
                              'At Risk Criteria',
                              style: TextStyle(
                                fontSize: fontSize + 1,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF44336),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Users are classified as "At Risk" if they meet any of these criteria:',
                          style: TextStyle(fontSize: fontSize - 1, color: Color(0xFF222B45)),
                        ),
                        SizedBox(height: 8),
                        _RiskCriteriaItem(
                          text: 'No login for 10+ days',
                          fontSize: fontSize,
                        ),
                        _RiskCriteriaItem(
                          text: 'No activity for 10+ days',
                          fontSize: fontSize,
                        ),
                        _RiskCriteriaItem(
                          text: 'Registered 7+ days ago but never logged in',
                          fontSize: fontSize,
                        ),
                      ],
                    ),
                  ),
                
                // User List
                _isLoading
                    ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _filteredActivities.isEmpty
                        ? Container(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                                  SizedBox(height: 16),
                                  Text(
                                    'No users found',
                                    style: TextStyle(fontSize: fontSize + 2, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: _filteredActivities.map((user) => 
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: _UserActivityCard(
                                    user: user,
                                    fontSize: fontSize,
                                  ),
                                ),
                              ).toList(),
                            ),
                          ),
              ],
            ),
          ),
        ),
        DraggableTTSFab(
          text: ttsText,
          fontSize: fontSize,
          volume: 1.0,
        ),
      ],
    );
  }
}

class UserActivityData {
  final String userId;
  final String name;
  final String category;
  final DateTime? lastLogin;
  final DateTime? lastActivity;
  final String status;
  final String riskReason;

  UserActivityData({
    required this.userId,
    required this.name,
    required this.category,
    this.lastLogin,
    this.lastActivity,
    required this.status,
    required this.riskReason,
  });
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;
  final double fontSize;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: fontSize + 8),
          SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: fontSize + 4,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize - 1,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RiskCriteriaItem extends StatelessWidget {
  final String text;
  final double fontSize;

  const _RiskCriteriaItem({
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: fontSize, color: Color(0xFFF44336))),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize - 1, color: Color(0xFF222B45)),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserActivityCard extends StatelessWidget {
  final UserActivityData user;
  final double fontSize;

  const _UserActivityCard({
    required this.user,
    required this.fontSize,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Color(0xFF4CAF50);
      case 'Inactive':
        return Color(0xFFFF9800);
      case 'At Risk':
        return Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Never';
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(user.status).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getStatusColor(user.status).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: _getStatusColor(user.status),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: fontSize + 1,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222B45),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.category,
                        style: TextStyle(
                          fontSize: fontSize - 1,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Last login: ${_formatDate(user.lastLogin)}',
                        style: TextStyle(
                          fontSize: fontSize - 2,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(user.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.status,
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(user.status),
                    ),
                  ),
                ),
              ],
            ),
            // Show risk reason for At Risk users
            if (user.status == 'At Risk' && user.riskReason.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF44336).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Risk: ${user.riskReason}',
                    style: TextStyle(
                      fontSize: fontSize - 2,
                      color: Color(0xFFF44336),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 