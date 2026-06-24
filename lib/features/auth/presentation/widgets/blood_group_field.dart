import 'package:flutter/material.dart';

class BloodGroupDropdown extends StatefulWidget {
  final String? selectedValue;
  final Function(String?)? onChanged;

  const BloodGroupDropdown({
    super.key,
    this.selectedValue,
    this.onChanged,
  });

  @override
  State<BloodGroupDropdown> createState() => _BloodGroupDropdownState();
}

class _BloodGroupDropdownState extends State<BloodGroupDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Blood Group",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 50,
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: widget.selectedValue,
              hint: const Text(
                "Blood group",
                style: TextStyle(
                  color: Color(0xFF707884),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF6B7280),
              ),
              items: const [
                DropdownMenuItem(value: "A+", child: Text("A+")),
                DropdownMenuItem(value: "A-", child: Text("A-")),
                DropdownMenuItem(value: "B+", child: Text("B+")),
                DropdownMenuItem(value: "B-", child: Text("B-")),
                DropdownMenuItem(value: "AB+", child: Text("AB+")),
                DropdownMenuItem(value: "AB-", child: Text("AB-")),
                DropdownMenuItem(value: "O+", child: Text("O+")),
                DropdownMenuItem(value: "O-", child: Text("O-")),
              ],
              onChanged: widget.onChanged,
            ),
          ),
        ),
      ],
    );
  }
}