class ConnectionRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime createdAt;

  ConnectionRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    return ConnectionRequest(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}