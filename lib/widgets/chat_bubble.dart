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
      bottomLeft: isSender ? Radius.circular(20) : Radius.circular(6),
      bottomRight: isSender ? Radius.circular(6) : Radius.circular(20),
    );
    final shadow = [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender)
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[400],
                child: Text(_getInitials(senderName), style: TextStyle(fontSize: fontSize * 0.8, color: Colors.white)),
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
                      style: TextStyle(fontSize: fontSize * 0.85, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    ),
                  ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                    gradient: isSender
                        ? LinearGradient(colors: [Colors.blue.shade200, Colors.blue.shade100])
                        : LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade100]),
                    borderRadius: radius,
                    boxShadow: shadow,
                  ),
                  child: Column(
                    crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(fontSize: fontSize, color: Colors.black87, height: 1.4),
                      ),
                      if (timestamp != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _formatTimestamp(timestamp!),
                            style: TextStyle(fontSize: fontSize * 0.7, color: Colors.grey[600]),
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
              padding: const EdgeInsets.only(left: 6.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue[400],
                child: Text(_getInitials(senderName), style: TextStyle(fontSize: fontSize * 0.8, color: Colors.white)),
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
