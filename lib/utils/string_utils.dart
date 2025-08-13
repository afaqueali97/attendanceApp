
/* Created By: Afaque Ali on 02-Oct-2023 */
import 'package:intl/intl.dart';

extension StringUtils on String {
  /// Created By: Afaque Ali on 10-Sep-2023
  bool equalsIgnoreCase(String b) => (replaceAll(' ', '')).toLowerCase() == (b.replaceAll(' ', '')).toLowerCase();
  /// Created By: Afaque Ali on 02-Oct-2023
  int get toInt => toDouble.ceil();
  /// Created By: Afaque Ali on 02-Oct-2023
  double get toDouble => double.tryParse(this)??0.0;

  /// Created By: Afaque Ali on 02-Oct-2023
  String get inRupee{
    final chars = split('');
    String newString = '';
    for (int i = chars.length - 1; i >= 0; i--) {
      if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
        newString = ",$newString";
      }
      newString = chars[i] + newString;
    }
    return "Rs. $newString";
  }

  /// Created By: Afaque Ali on 09-Oct-2023
  String get formatDate {
    DateTime? dateTime  = DateTime.tryParse(this);
    if(dateTime != null){
       return DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return replaceAll('/', '-');
  }

  /// Created By: Afaque Ali on 29-May-2024
  DateTime get parseToDateTime {
    DateTime? dateTime = DateTime.tryParse(this);
    if( dateTime != null) return dateTime;
    try{
      return DateFormat('dd-MM-yyyy').parse(replaceAll('/', '-'));
    }catch(_){}
    return DateTime.now();
  }

  /// Created By: Afaque Ali on 29-Aug-2024
  String get phoneFormatWithHyphen {
    if (!contains('-')) {
      return '${substring(0, 4)}-${substring(4)}';
    } else {
      return this;
    }
  }

}
