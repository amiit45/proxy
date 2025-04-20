import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/providers/app_state.dart';
import '/routes.dart';

class RequestsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Connection Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          appState.pendingRequests.isEmpty
              ? Text('No pending requests')
              : Expanded(
            child: ListView.builder(
              itemCount: appState.pendingRequests.length,
              itemBuilder: (ctx, index) {
                final request = appState.pendingRequests[index];
                return ListTile(
                  title: Text('Anonymous User'),
                  subtitle: Text('Wants to connect with you'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await appState.respondToRequest(request.id, true);
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            Routes.chat,
                            arguments: {'chatId': request.id},
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          appState.respondToRequest(request.id, false);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}