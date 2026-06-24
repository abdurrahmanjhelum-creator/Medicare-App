import 'package:flutter/material.dart';

class QualificationDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const QualificationDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: "Highest Qualification *",
        border: OutlineInputBorder(),
      ),
      items: [
        "MBBS",
        "FCPS",
        "MD",
        "PhD",
        "MS",
        "BDS",
      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
