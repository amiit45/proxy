import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '/core/models/chat_message.dart';
import '/core/services/api_service.dart';
import '/core/constants/api_constants.dart';

class ChatService {
  final ApiService _apiService;

  ChatService(this._apiService);

  WebSocketChannel connectToChat(String chatId, String token) {
    final channel = WebSocketChannel.connect(
      Uri.parse('${ApiConstants.wsUrl}/api/ws/chat/$chatId'),
    );

    // Add authorization header
    channel.sink.add(jsonEncode({
      'type': 'auth',
      'token': token,
    }));

    return channel;
  }

  void sendMessage(WebSocketChannel channel, String message) {
    channel.sink.add(jsonEncode({
      'type': 'message',
      'text': message,
    }));
  }

  ChatMessage parseMessage(String messageJson, String userId) {
    final data = jsonDecode(messageJson);
    return ChatMessage(
      text: data['text'],
      isMe: data['sender_id'] == userId,
      timestamp: DateTime.parse(data['timestamp']),
    );
  }
}