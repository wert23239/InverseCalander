import 'package:flutter/material.dart';
import 'availability_form.dart';
import 'shared_calendars.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Map to store availability: Key is "day_time", Value is the selected activity
  Map<String, String> availability = {};

  // Callback to save availability
  void saveAvailability(String day, String time, String activity) {
    setState(() {
      if (activity == "None") {
        availability.remove("${day}_$time");
        return;
      }
      availability["${day}_$time"] = activity;
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
                    saveAvailability: saveAvailability,
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
  final Map<String, String> availability;
  final Function(String, String, String) saveAvailability;

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
}

class TimeSlot extends StatelessWidget {
  final String day;
  final String time;
  final Map<String, String> availability;
  final Function(String, String, String) saveAvailability;

  const TimeSlot({
    required this.day,
    required this.time,
    required this.availability,
    required this.saveAvailability,
  });

  @override
  Widget build(BuildContext context) {
    final key = "${day}_$time";
    final activity = availability[key];

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
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Bold text
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
              )
            else
              Icon(Icons.add_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
