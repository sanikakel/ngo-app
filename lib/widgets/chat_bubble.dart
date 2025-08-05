import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String? senderName;
  final DateTime? timestamp;
  final double fontSize;
  final Color senderColor;
  final Color receiverColor;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isSender,
    this.senderName,
    this.timestamp,
    required this.fontSize,
    required this.senderColor,
    required this.receiverColor,
  });

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "";
    return name.trim().split(" ").map((e) => e[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {

    final radius = BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomLeft: isSender ? Radius.circular(20) : Radius.circular(10),
      bottomRight: isSender ? Radius.circular(10) : Radius.circular(20),
    );
    final shadow = [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ];
    // iMessage/Google Chat-like subtle colors
    final Color senderBubble = Color(0xFFD2E3FC); // soft blue
    final Color receiverBubble = Color(0xFFF2F2F7); // light gray
    final Color senderProfile = Color(0xFF90CAF9); // soft blue accent
    final Color receiverProfile = Color(0xFFB0BEC5); // soft blue-gray
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: receiverProfile,
                child: Text(_getInitials(senderName), style: TextStyle(fontSize: fontSize * 0.8, color: Color(0xFF222B45), fontWeight: FontWeight.bold)),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (senderName != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6, bottom: 2),
                    child: Text(
                      senderName!,
                      style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    ),
                  ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSender ? senderBubble : receiverBubble,
                    borderRadius: radius,
                    boxShadow: shadow,
                  ),
                  child: Column(
                    crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(fontSize: fontSize + 1, color: Color(0xFF222B45), height: 1.5, fontWeight: FontWeight.w500),
                      ),
                      if (timestamp != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _formatTimestamp(timestamp!),
                            style: TextStyle(fontSize: fontSize * 0.75, color: Colors.grey[600]),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isSender)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: senderProfile,
                child: Text(_getInitials(senderName), style: TextStyle(fontSize: fontSize * 0.8, color: Color(0xFF222B45), fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }
}
