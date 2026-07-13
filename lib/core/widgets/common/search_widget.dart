import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;
  final FocusNode? focusNode;

  const SearchWidget({
    super.key,
    this.hintText = "Search...",
    this.onChanged,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        onTap: onTap,
        autofocus: autofocus,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
        ),
      ),
    );
  }
}
