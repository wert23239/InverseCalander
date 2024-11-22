import 'package:flutter/material.dart';

class SharedCalendars extends StatefulWidget {
  @override
  _SharedCalendarsState createState() => _SharedCalendarsState();
}

class _SharedCalendarsState extends State<SharedCalendars> {
  // Fake data for other users' calendars
  final Map<String, Map<String, List<String>>> mockSharedAvailability = {
    'Friday': {
      'Morning': ['Alice 🎉', 'Bob 🏀'],
      'Day': ['Charlie 😎'],
      'Night': ['Alice 🎉', 'Bob 🏀', 'Charlie 😎'],
    },
    'Saturday': {
      'Morning': ['Alice 🏀', 'Charlie 😎'],
      'Day': ['Bob 🎉', 'Charlie 🏀'],
      'Night': ['Alice 😎', 'Bob 🎉'],
    },
    'Sunday': {
      'Morning': ['Alice 🎉'],
      'Day': [],
      'Night': ['Charlie 🏀', 'Bob 🎉'],
    },
  };

  // Map to track liked people
  Map<String, Set<String>> likes = {};
  Map<String, bool> isAnimating = {}; // Track animation state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Availability'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: mockSharedAvailability.keys.map((day) {
          final times = mockSharedAvailability[day]!;
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(vertical: 8),
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
                  const SizedBox(height: 8),
                  ...times.keys.map((time) {
                    final people = times[time]!;
                    return Column(
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
                        ...people.map((person) {
                          final key = '${day}_$time';
                          final isLiked = likes[key]?.contains(person) ?? false;

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              person,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                // Handle like toggle and animation
                                setState(() {
                                  if (!likes.containsKey(key)) {
                                    likes[key] = {};
                                  }
                                  if (isLiked) {
                                    likes[key]?.remove(person);
                                  } else {
                                    likes[key]?.add(person);
                                  }

                                  isAnimating['${key}_$person'] = true;
                                });
                              },
                              child: AnimatedScale(
                                scale: isAnimating['${key}_$person'] == true
                                    ? 1.4
                                    : 1.0,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                onEnd: () {
                                  setState(() {
                                    isAnimating['${key}_$person'] = false;
                                  });
                                },
                                child: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class UserCalendar extends StatelessWidget {
  final String name;
  final Map<String, Map<String, String?>> availability;

  const UserCalendar({
    required this.name,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name's Calendar"),
      ),
      body: ListView(
        children: availability.keys.map((day) {
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                day,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              subtitle: Text(
                _formatAvailability(availability[day]!),
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              onTap: () {
                // Additional functionality (like showing more details) can be added here
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatAvailability(Map<String, String?> dayAvailability) {
    List<String> parts = [];
    dayAvailability.forEach((time, activity) {
      if (activity != null) {
        parts.add("$time: $activity");
      }
    });
    return parts.isEmpty ? "No availability" : parts.join(", ");
  }
}
