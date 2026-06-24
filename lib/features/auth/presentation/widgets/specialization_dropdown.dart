import 'package:flutter/material.dart';

class SpecializationDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const SpecializationDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: "Specialization *",
        border: OutlineInputBorder(),
      ),
      items: [
        "General Physician",
        "Cardiologist",
        "Neurologist",
        "Surgeon",
        "Dentist",
        "Pediatrician",
        "Orthopedic",
        "Dermatologist",
        "Gynecologist",
      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
