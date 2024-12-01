import 'package:flutter/material.dart';

class SharedCalendars extends StatefulWidget {
  @override
  _SharedCalendarsState createState() => _SharedCalendarsState();
}

class _SharedCalendarsState extends State<SharedCalendars> {
  // Fake data for other users' calendars
  Map<String, Map<String, List<String>>> mockSharedAvailability = {
    'Friday': {
      'Morning': ['Sarah 🎉', 'Bob 🏀'],
      'Day': ['Charlie 😎'],
      'Night': ['Sarah 🎉', 'Bob 🏀', 'Charlie 😎'],
    },
    'Saturday': {
      'Morning': ['Sarah 🏀', 'Charlie 😎'],
      'Day': ['Bob 🎉', 'Charlie 🏀'],
      'Night': ['Sarah 😎', 'Bob 🎉'],
    },
    'Sunday': {
      'Morning': ['Sarah 🎉'],
      'Day': [],
      'Night': ['Charlie 🏀', 'Bob 🎉'],
    },
  };

  // Map to track liked people
  Map<String, Set<String>> likes = {};
  Map<String, bool> isAnimating = {}; // Track animation state

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Filter by Activity',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  // Apply Party filter
                  Navigator.pop(context);
                  setState(() {
                    _applyFilter('🎉');
                  });
                },
                child: Text(
                  'Party 🎉',
                  style: TextStyle(color: Colors.pinkAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Apply Chill filter
                  Navigator.pop(context);
                  setState(() {
                    _applyFilter('😎');
                  });
                },
                child: Text(
                  'Chill 😎',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Apply Sports filter
                  Navigator.pop(context);
                  setState(() {
                    _applyFilter('🏀');
                  });
                },
                child: Text(
                  'Sports 🏀',
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
              Divider(color: Colors.grey),
              TextButton(
                onPressed: () {
                  // Reset to unfiltered view
                  Navigator.pop(context);
                  setState(() {
                    _resetFilter();
                  });
                },
                child: Text(
                  'Show All',
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(String activityEmoji) {
    // Filter mockSharedAvailability by the selected activity
    mockSharedAvailability.forEach((day, times) {
      times.forEach((time, people) {
        times[time] =
            people.where((person) => person.contains(activityEmoji)).toList();
      });
    });
  }

  void _resetFilter() {
    // Restore mockSharedAvailability to its original state
    mockSharedAvailability = {
      'Friday': {
        'Morning': ['Sarah 🎉', 'Bob 🏀'],
        'Day': ['Charlie 😎'],
        'Night': ['Sarah 🎉', 'Bob 🏀', 'Charlie 😎'],
      },
      'Saturday': {
        'Morning': ['Sarah 🏀', 'Charlie 😎'],
        'Day': ['Bob 🎉', 'Charlie 🏀'],
        'Night': ['Sarah 😎', 'Bob 🎉'],
      },
      'Sunday': {
        'Morning': ['Sarah 🎉'],
        'Day': [],
        'Night': ['Charlie 🏀', 'Bob 🎉'],
      },
    };
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterDialog(context); // Opens the filter dialog
        },
        child: Icon(Icons.filter_list, color: Colors.white),
        backgroundColor: Colors.blue,
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
