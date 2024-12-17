import 'package:flutter/material.dart';
import 'account_model.dart';

class CustomListsScreen extends StatelessWidget {
  final Map<String, List<Friend>> customLists;

  const CustomListsScreen({required this.customLists});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Lists"),
      ),
      body: ListView(
        children: customLists.keys.map((listName) {
          final list = customLists[listName]!;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(listName),
              subtitle: Text(
                "Members: ${list.map((friend) => friend.name).join(', ')}",
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Icon(Icons.group, color: Colors.blue),
              onTap: () {
                // Show list details or edit members
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
