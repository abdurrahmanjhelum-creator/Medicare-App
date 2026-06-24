import 'package:flutter/material.dart';

class AvailableDaysWidget extends StatelessWidget {
  final List<String> selectedDays;
  final Function(String, bool) onDaySelected;

  const AvailableDaysWidget({
    super.key,
    required this.selectedDays,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Days *",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
              .map(
                (day) => FilterChip(
              label: Text(day),
              selected: selectedDays.contains(day),
              onSelected: (value) =>
                  onDaySelected(day, value),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}