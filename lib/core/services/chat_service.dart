import 'dart:convert';
import 'package:test1/core/services/api_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '/core/models/chat_message.dart';
import '/core/constants/api_constants.dart';

class ChatService {
  ChatService(ApiService apiService);

  WebSocketChannel connectToChat(String chatId, String token) {
    final uri = Uri.parse('${ApiConstants.wsUrl}/api/ws/chat/$chatId');

    // Since WebSocketChannel.connect does not support headers directly,
    // we include the token as a query parameter for authorization if backend supports it.
    // Otherwise, a custom WebSocket client implementation is needed.

    final uriWithToken = uri.replace(queryParameters: {'token': token});

    final channel = WebSocketChannel.connect(uriWithToken);

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
