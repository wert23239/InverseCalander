import 'package:flutter/material.dart';

class AvailabilityForm extends StatelessWidget {
  final String day;
  final String time;
  final Function(String, String, String) saveAvailability;

  const AvailabilityForm({
    required this.day,
    required this.time,
    required this.saveAvailability,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Availability'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ActivityOption(
              activity: 'Party',
              onSelect: () {
                saveAvailability(day, time, 'Party');
                Navigator.pop(context);
              },
            ),
            ActivityOption(
              activity: 'Workout',
              onSelect: () {
                saveAvailability(day, time, 'Workout');
                Navigator.pop(context);
              },
            ),
            ActivityOption(
              activity: 'Chill',
              onSelect: () {
                saveAvailability(day, time, 'Chill');
                Navigator.pop(context);
              },
            ),
            ActivityOption(
              activity: 'None',
              onSelect: () {
                saveAvailability(day, time, 'None');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityOption extends StatelessWidget {
  final String activity;
  final VoidCallback onSelect;

  const ActivityOption({
    required this.activity,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Card(
        color: Colors.grey[800],
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            activity,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
