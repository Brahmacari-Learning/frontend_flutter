import 'package:flutter/material.dart';

class InputRoundedWithIcon extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final dynamic Function(String text) onEnter;

  const InputRoundedWithIcon({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    required this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.3,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w400),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () => onEnter(controller.text),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Icon(
              icon,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}
