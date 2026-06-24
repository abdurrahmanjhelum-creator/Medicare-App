import 'package:flutter/material.dart';

class ExperienceDropdown extends StatelessWidget {
  final int value;
  final Function(int?) onChanged;

  const ExperienceDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: "Years of Experience *",
        border: OutlineInputBorder(),
      ),
      items: List.generate(
        41,
        (index) => DropdownMenuItem(value: index, child: Text("$index years")),
      ),
      onChanged: onChanged,
    );
  }
}
