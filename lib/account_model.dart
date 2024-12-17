// lib/models/account_model.dart

class User {
  final String username;
  final String profilePicture;

  User({required this.username, required this.profilePicture});
}

class Friend {
  final String name;
  final String username;
  final List<String> tags; // e.g., ["Party", "Soccer"]

  Friend({required this.name, required this.username, required this.tags});
}

final User currentUser = User(
  username: "sarah123",
  profilePicture:
      "https://via.placeholder.com/150", // Replace with actual images
);

final List<Friend> friends = [
  Friend(name: "Sarah", username: "sarah001", tags: ["Soccer"]),
  Friend(name: "Bob", username: "bob_the_party", tags: ["Party", "Soccer"]),
  Friend(name: "Charlie", username: "chill_charlie", tags: ["Chill"]),
];

final Map<String, List<Friend>> customLists = {
  "Party Friends": [friends[1]], // Bob
  "Soccer Friends": [friends[0], friends[1]], // Sarah, Bob
};
