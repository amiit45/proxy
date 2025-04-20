import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/providers/app_state.dart';
import '/features/home/widgets/nearby_user_item.dart';
import '/features/home/widgets/requests_bottom_sheet.dart';
import '/routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => RequestsBottomSheet(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              appState.logout();
              Navigator.pushReplacementNamed(context, Routes.auth);
            },
          ),
        ],
      ),
      body: appState.nearbyUsers.isEmpty
          ? Center(child: Text('No users nearby'))
          : ListView.builder(
        itemCount: appState.nearbyUsers.length,
        itemBuilder: (ctx, index) {
          final user = appState.nearbyUsers[index];
          return NearbyUserItem(
            user: user,
            index: index,
            onConnectPressed: () {
              appState.sendConnectionRequest(user.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Request sent')),
              );
            },
          );
        },
      ),
    );
  }
}