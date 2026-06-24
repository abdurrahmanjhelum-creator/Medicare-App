import 'package:flutter/material.dart';

class PhoneNumberTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;

  const PhoneNumberTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phone Number",
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
            onChanged: onChanged,
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText ?? "xxxx-xxxxxxx",
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 112, 120, 132),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Icon(
                  Icons.call_outlined,
                  color: Color(0xFF6B7280),
                  size: 25,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}