import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  const SearchWidget({super.key, this.hintText = "Search..."});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Set height here
      child: TextField(
        textAlignVertical: TextAlignVertical.center, // Centers text vertically
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          // contentPadding ensures the text isn't cut off inside the 50px height
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}