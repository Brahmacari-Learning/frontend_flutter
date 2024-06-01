import 'package:flutter/material.dart';

ElevatedButton buttonOptionFullWidth(String text, void Function() onClick) {
  return ElevatedButton(
    onPressed: onClick,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF9C7AFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      // ignore: prefer_const_constructors
      side: BorderSide(
        color: const Color.fromARGB(172, 255, 255, 255),
        width: 2.0,
      ),
      minimumSize: const Size(double.infinity, 70),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}
