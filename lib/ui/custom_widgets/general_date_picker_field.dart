 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/date_time_manager.dart';


class GeneralDatePickerField extends StatelessWidget {

  final DateTimeManager dateManager;
  final double paddingHorizontal;
  final bool _withShadow=false;
  final bool readOnly;
  final VoidCallback? onDateChange;

  GeneralDatePickerField.withShadow({super.key,
    required this.dateManager,
    this.paddingHorizontal=4,
    this.readOnly = false,
    this.onDateChange,
  }){
    // _withShadow=true;
  }

  const GeneralDatePickerField.withBorder({super.key,
    required this.dateManager,
    this.paddingHorizontal=0,
    this.readOnly=false,
    this.onDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: kFieldVerticalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(text: dateManager.fieldName,
            style: const TextStyle(color: kTextColor),
            children: const [
              TextSpan(text: '*', style: TextStyle(color: kRequiredRedColor, fontWeight: FontWeight.bold))
            ],
          )),

          // Text(dateManager.fieldName, style: const TextStyle(color: kTextColor, fontSize: 14),),
          GestureDetector(
            onTap: readOnly ? null : _selectDate,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_withShadow ? 4 : kFieldRadius),
                border:  _withShadow ? null : Border.all(color: kFieldBorderColor),
                color: readOnly ? kFieldGreyColor : _withShadow ? kWhiteColor : kWhiteColor,
                boxShadow: _withShadow ? [
                  const BoxShadow(blurRadius: 3,spreadRadius: 1, color: kFieldShadowColor)
                ] : null,
              ),
              margin: const EdgeInsets.only(top: 7),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(()=> Flexible(child: Text("${dateManager.formattedDateTime.isEmpty ? 'Select ${dateManager.fieldName}' : dateManager.formattedDateTime}", overflow :TextOverflow.ellipsis, style: TextStyle(fontSize: 16, color: readOnly ? kGreyColor : dateManager.formattedDateTime.isEmpty ? kTextHintColor: kTextColor),))),
                  Image.asset('assets/icons/calendar.png', color: kBlackColor, width: 24, height: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Visibility(
            visible: dateManager.errorMessage.value.isNotEmpty,
            child: Text(dateManager.errorMessage.value, style: const TextStyle(color: kRequiredRedColor, fontSize: 12),),
          )),

        ],
      ),
    );
  }

  void _selectDate() async {
    var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    try {
      DateTime? initDate = dateManager.dateTime;
      if(initDate==null){
        if(now.toString().split(' ').first == dateManager.firstDate.toString().split(' ').first){
          initDate =  dateManager.firstDate;
        } else if(now.toString().split(' ').first == dateManager.lastDate.toString().split(' ').first){
          initDate =  dateManager.lastDate;
        } else if(now.isAfter(dateManager.lastDate)){
          initDate =  dateManager.lastDate;
        } else if(now.isBefore(dateManager.firstDate)){
          initDate =  dateManager.firstDate;
        } else {
         initDate = now;
        }

      }
      final date = await showDatePicker(
        context: Get.context!,
        initialDate: initDate,
        firstDate: dateManager.firstDate,
        lastDate: dateManager.lastDate,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: kPrimaryColor,
              buttonTheme: const ButtonThemeData(buttonColor: kPrimaryColor), colorScheme: const ColorScheme.light(primary: kPrimaryColor).copyWith(secondary: kPrimaryColor),
            ),
            child: child!,
          );
        },
      );
      if (date!=null) {
        dateManager.validateDate(date: date);
        if(onDateChange != null) {
          onDateChange!();
        }
      }
    } catch (_) {}
  }


}
