import 'package:flutter/material.dart';
import 'account_model.dart';

class FriendsListScreen extends StatelessWidget {
  final List<Friend> friends;

  const FriendsListScreen({required this.friends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(friend.name),
              subtitle: Text(
                "Tags: ${friend.tags.join(', ')}",
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Icon(Icons.person, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
