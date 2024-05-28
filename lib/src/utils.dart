import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('dd MMM yyyy').format(dateTime);
}
