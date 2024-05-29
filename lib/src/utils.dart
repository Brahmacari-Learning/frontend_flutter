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
