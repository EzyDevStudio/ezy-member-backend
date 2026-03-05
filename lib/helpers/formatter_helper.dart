import 'package:ezymember_backend/language/globalization.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormatterHelper {
  FormatterHelper._();

  static const String formatDate = "yyyy-MM-dd";
  static const String formatDateTime = "yyyy-MM-dd, HH:mm";

  static String _dateTimeToString(DateTime? value, {String format = formatDate}) {
    if (value == null) return "";

    return DateFormat(format).format(value);
  }

  static String _timestampToString(int? value, {String format = formatDate}) {
    if (value == null || value == 0) return "";

    DateTime date = DateTime.fromMillisecondsSinceEpoch(value);

    return _dateTimeToString(date, format: format);
  }

  static String _timestampToStringWithDays(int value, {String format = formatDate}) {
    if (value == 0) return "";

    DateTime date = DateTime.fromMillisecondsSinceEpoch(value);
    DateTime now = DateTime.now();
    int days = now.difference(date).inDays;
    String formattedDate = _dateTimeToString(date, format: format);

    return "$formattedDate ($days ${Globalization.days.tr})";
  }

  static DateTime _stringToDateTime(String value, {String format = formatDate}) {
    return DateFormat(format).parse(value);
  }

  static int _stringToTimestamp(String dateString, {String format = formatDate}) {
    DateTime date = _stringToDateTime(dateString, format: format);

    return date.millisecondsSinceEpoch;
  }

  static bool _isExpired(int? value, {bool includeToday = false}) {
    if (value == null) return false;

    DateTime date = DateTime.fromMillisecondsSinceEpoch(value);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, includeToday ? now.day + 1 : now.day);

    return date.isBefore(today);
  }
}

extension BooleanFormatting on int {
  bool get isExpired => FormatterHelper._isExpired(this);
  bool get isExpiredToday => FormatterHelper._isExpired(this, includeToday: true);
}

extension DateTimeFormatting on DateTime {
  String get dtToStr => FormatterHelper._dateTimeToString(this);
}

extension StringFormatting on String {
  DateTime get strToDT => FormatterHelper._stringToDateTime(this);
  int get strToTS => FormatterHelper._stringToTimestamp(this);
}

extension TimestampFormatting on int {
  String get tsToStr => FormatterHelper._timestampToString(this);
  String get tsToStrWithDays => FormatterHelper._timestampToStringWithDays(this);
  String get tsToStrDateTime => FormatterHelper._timestampToString(this, format: FormatterHelper.formatDateTime);
}
