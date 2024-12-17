import 'package:flutter/material.dart';

class AvailabilityForm extends StatefulWidget {
  final String day;
  final String time;
  final Function(String, String, String, List<String>) saveAvailability;

  const AvailabilityForm({
    required this.day,
    required this.time,
    required this.saveAvailability,
  });

  @override
  _AvailabilityFormState createState() => _AvailabilityFormState();
}

class _AvailabilityFormState extends State<AvailabilityForm> {
  String? selectedActivity;
  List<String> selectedVisibility = [];

  final List<String> customLists = [
    "Party Friends",
    "Soccer Friends",
    "All Friends"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Availability"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedActivity,
              hint: Text("Select Activity"),
              items: ["Party", "Workout", "Chill"].map((activity) {
                return DropdownMenuItem(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text("Select Visibility:"),
            Wrap(
              spacing: 8.0,
              children: customLists.map((list) {
                final isSelected = selectedVisibility.contains(list);
                return FilterChip(
                  label: Text(list),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedVisibility.add(list);
                      } else {
                        selectedVisibility.remove(list);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedActivity != null && selectedVisibility.isNotEmpty) {
                  widget.saveAvailability(
                    widget.day,
                    widget.time,
                    selectedActivity!,
                    selectedVisibility,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please select an activity and visibility"),
                  ));
                }
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
