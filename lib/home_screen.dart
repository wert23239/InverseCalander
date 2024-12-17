import 'package:flutter/material.dart';
import 'availability_form.dart';
import 'shared_calendars.dart';
import 'friends_list.dart';
import 'custom_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Map to store availability: Key is "day_time", Value is the selected activity and likes
  Map<String, Map<String, dynamic>> availability = {
    "Friday_Morning": {
      "activity": "Party",
      "likes": ["Bob"],
      "visibility": ["Party Friends"], // Shared only with Party Friends
    },
    "Friday_Night": {
      "activity": "Chill",
      "likes": ["Charlie"],
      "visibility": ["Soccer Friends"], // Shared only with Soccer Friends
    },
  };
  // Callback to save availability
  void saveAvailability(
      String day, String time, String activity, List<String> visibility) {
    setState(() {
      final key = "${day}_$time";
      if (activity == "None") {
        availability.remove(key);
        return;
      }
      if (!availability.containsKey(key)) {
        availability[key] = {
          "activity": activity,
          "likes": [],
          "visibility": visibility,
        };
      } else {
        availability[key]!["activity"] = activity;
      }
    });
    print("added $availability");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InverseCalendar'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Friends List"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendsListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Custom Lists"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomListsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your Availability',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  DayAvailability(
                    day: 'Friday',
                    availability: availability,
                    saveAvailability: saveAvailability, // Use the wrapper
                  ),
                  DayAvailability(
                    day: 'Saturday',
                    availability: availability,
                    saveAvailability: saveAvailability,
                  ),
                  DayAvailability(
                    day: 'Sunday',
                    availability: availability,
                    saveAvailability: saveAvailability,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SharedCalendars()),
          );
        },
        child: Icon(Icons.group, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class DayAvailability extends StatelessWidget {
  final String day;
  final Map<String, Map<String, dynamic>> availability;
  final Function(String, String, String, List<String>) saveAvailability;

  const DayAvailability({
    required this.day,
    required this.availability,
    required this.saveAvailability,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900], // Dark theme for cards
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            TimeSlot(
              day: day,
              time: 'Morning',
              availability: availability,
              saveAvailability: saveAvailability,
            ),
            TimeSlot(
              day: day,
              time: 'Day',
              availability: availability,
              saveAvailability: saveAvailability,
            ),
            TimeSlot(
              day: day,
              time: 'Night',
              availability: availability,
              saveAvailability: saveAvailability,
            ),
          ],
        ),
      ),
    );
  }

  void saveAvailabilityWrapper(String day, String time, String activity) {
    saveAvailability(day, time, activity, ["All Friends"]);
  }
}

class TimeSlot extends StatelessWidget {
  final String day;
  final String time;
  final Map<String, Map<String, dynamic>> availability;
  final Function(String, String, String, List<String>) saveAvailability;

  const TimeSlot({
    required this.day,
    required this.time,
    required this.availability,
    required this.saveAvailability,
  });

  @override
  Widget build(BuildContext context) {
    final key = "${day}_$time";
    final slotData = availability[key] ?? {};
    final activity = slotData["activity"];
    final likes = slotData["likes"] ?? [];
    final visibility = slotData["visibility"] ?? ["All Friends"];

    // Determine background color and emoji based on activity
    Color backgroundColor;
    String emoji = '';
    if (activity == 'Party') {
      backgroundColor = Color(0xFFD81B60); // Vibrant pink for Party
      emoji = '🎉';
    } else if (activity == 'Workout') {
      backgroundColor = Color(0xFFE53935); // Energetic red for Workout
      emoji = '🏀';
    } else if (activity == 'Chill') {
      backgroundColor = Color(0xFF1976D2); // Cool blue for Chill
      emoji = '😎';
    } else {
      backgroundColor = Colors.grey[800]!;
    }

    return InkWell(
      onTap: () {
        // Navigate to AvailabilityForm to edit the slot
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AvailabilityForm(
              day: day,
              time: time,
              saveAvailability: saveAvailability,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8), // Match the container's border
      splashColor: Colors.white24, // Ripple effect color
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Display the time and activity
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (activity != null)
                  Row(
                    children: [
                      Text(
                        emoji,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 8),
                      Text(
                        activity,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                if (likes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Liked by: ${likes.join(', ')}",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "No likes yet",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                // Display visibility
                if (visibility.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Visible to: ${visibility.join(', ')}",
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show likes in a dialog
  void _showLikesDialog(BuildContext context, List<String> likes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Likes',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: likes
                .map((like) => Text(
                      like,
                      style: TextStyle(color: Colors.white),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
