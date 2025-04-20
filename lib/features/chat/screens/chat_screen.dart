import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import '/core/providers/app_state.dart';
import '/core/models/chat_message.dart';
import '/core/services/service_locator.dart';
import '/core/services/chat_service.dart';
import '/features/chat/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late WebSocketChannel _channel;
  List<ChatMessage> _messages = [];
  late String _chatId;
  late ChatService _chatService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _chatId = args['chatId'];
    final appState = Provider.of<AppState>(context, listen: false);
    _chatService = getIt<ChatService>();

    // Connect to WebSocket
    _channel = _chatService.connectToChat(_chatId, appState.token);

    // Listen for messages
    _channel.stream.listen((message) {
      final chatMessage = _chatService.parseMessage(message, appState.userId);
      setState(() {
        _messages.add(chatMessage);
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anonymous Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(child: Text('No messages yet. Say hello!'))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final message = _messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                FloatingActionButton(
                  mini: true,
                  child: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _chatService.sendMessage(_channel, _messageController.text.trim());
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}