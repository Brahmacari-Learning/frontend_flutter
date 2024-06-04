import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('dd MMM yyyy').format(dateTime);
}

// Ucapan selamat pagi, siang, sore, malam
String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 11) {
    return 'Selamat Pagi';
  }
  if (hour < 15) {
    return 'Selamat Siang';
  }
  if (hour < 18) {
    return 'Selamat Sore';
  }
  return 'Selamat Malam';
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
