import 'package:flutter/material.dart';
import '/core/models/nearby_user.dart';

class NearbyUserItem extends StatelessWidget {
  final NearbyUser user;
  final int index;
  final VoidCallback onConnectPressed;

  const NearbyUserItem({
    Key? key,
    required this.user,
    required this.index,
    required this.onConnectPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Anonymous User'),
      subtitle: Text('${user.distance.toStringAsFixed(2)} km away'),
      leading: CircleAvatar(
        child: Text('${index+1}'),
      ),
      trailing: ElevatedButton(
        child: Text('Connect'),
        onPressed: onConnectPressed,
      ),
    );
  }
}