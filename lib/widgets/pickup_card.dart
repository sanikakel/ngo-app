import 'package:flutter/material.dart';

class PickupCard extends StatelessWidget {
  final double fontSize;
  final VoidCallback? onResume;
  const PickupCard({super.key, required this.fontSize, this.onResume});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.09),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2DBEF4).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.play_arrow_rounded, color: Color(0xFF2DBEF4), size: 32),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              'Pick up where you left off',
              style: TextStyle(
                fontSize: fontSize + 1,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: onResume,
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF7C4DFF),
              side: BorderSide(color: Color(0xFFB39DDB)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
            ),
            child: Text('Resume'),
          ),
        ],
      ),
    );
  }
}
