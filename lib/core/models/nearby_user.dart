class NearbyUser {
  final String id;
  final double distance; // in kilometers

  NearbyUser({required this.id, required this.distance});

  factory NearbyUser.fromJson(Map<String, dynamic> json) {
    return NearbyUser(
      id: json['id'],
      distance: json['distance'].toDouble(),
    );
  }
}