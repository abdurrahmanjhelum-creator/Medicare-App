import 'package:flutter/material.dart';

class ClinicField extends StatelessWidget {
  final TextEditingController? controller;

  const ClinicField({
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Clinic/Hospital Name",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 14),

        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,

              hintText: "Enter clinic name",

              hintStyle: TextStyle(
                color: Color.fromARGB(255, 112, 120, 132),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),

              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Icon(
                  Icons.local_hospital_outlined,
                  color: Color(0xFF6B7280),
                  size: 25,
                ),
              ),

              prefixIconConstraints:
              BoxConstraints(minWidth: 20),

              contentPadding:
              EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}