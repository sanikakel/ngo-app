import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double fontSize;
  final Color? textColor;

  const DashboardCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.fontSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: fontSize * 0.3),
        padding: EdgeInsets.all(fontSize),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(fontSize * 0.75),
              child: Icon(icon, color: Colors.white, size: fontSize * 1.6),
            ),
            SizedBox(width: fontSize * 0.9),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
