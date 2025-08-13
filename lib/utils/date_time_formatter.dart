import 'package:intl/intl.dart';

/// Created: Amjad Jamali on 03-Jan-2023

class DateTimeFormatter {

  static String getFormattedDate(String dateTime, {String pattern="dd-MM-yyyy"}) {
    try {
      return DateFormat(pattern).format(DateTime.parse(dateTime)).toUpperCase();
    }catch(_){
      return dateTime;
    }
  }

  static String getFormattedToday({String pattern="dd-MM-yyyy"}) {
      return DateFormat(pattern).format(DateTime.now());
  }

}
