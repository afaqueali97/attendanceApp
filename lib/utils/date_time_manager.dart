import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../utils/user_session.dart';

class DateTimeManager {

  DateTime? dateTime;
  DateTime firstDate;
  DateTime lastDate;
  String fieldName;
  RxString formattedDateTime = "".obs;
  RxString errorMessage=''.obs;
  String pattern;

  DateTimeManager(this.fieldName, {this.pattern='dd-MM-yyyy', DateTime? firstDate, DateTime? lastDate}) :
        firstDate=firstDate??DateTime.now(),
        lastDate=lastDate??DateTime(DateTime.now().year+10, DateTime.now().month, DateTime.now().day);

  bool validateDate({DateTime? date}){
    if(date!=null) {
      dateTime = date;
    }
    if (dateTime != null && !(dateTime.isBlank!)) {
      formattedDateTime.value = DateFormat(pattern).format(dateTime!);
      errorMessage.value = "";
      UserSession.isDataChanged.value = true;
    } else {
      dateTime = null;
      formattedDateTime.value = "";
      errorMessage.value = "$fieldName is required";
    }
    return errorMessage.isEmpty;
  }


  String getFormattedDateTime({String? pattern}){
    if(dateTime!=null && !dateTime.isBlank!) {
      return DateFormat(pattern??this.pattern).format(dateTime!);
    } else {
      return formattedDateTime.value;
    }
  }


  void clear(){
    dateTime=null;
    formattedDateTime.value = "";
    errorMessage.value='';
  }

  void parse(String dateStr){
    dateTime  = DateTime.tryParse(dateStr);
    if(dateTime == null){
      try {
        dateTime = DateFormat(pattern).parse(dateStr.replaceAll('/', '-'));
      }catch(_){}
    }
    if(dateTime != null){
      if(!dateTime!.isBefore(firstDate) && !dateTime!.isAfter(lastDate)){
        validateDate();
      } else {
        dateTime = null;
        formattedDateTime.value = '';
      }
    }
  }
}