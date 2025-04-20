import 'package:flutter/material.dart';
import '/core/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10.0,
                color: message.isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}