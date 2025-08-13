import '../../utils/text_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/text_field_manager.dart';

class GeneralTextField extends StatelessWidget {

  final TextFieldManager tfManager;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChange;
  final Function(String)? callback;
  final int maxLines;
  final double paddingHorizontal;
  final bool readOnly;
  final TextAlign textAlign;
  final RxBool _obscure = false.obs;
  final Icon? suffixIcon;

  GeneralTextField.withBorder(
      {Key? key,
      required this.tfManager,
      this.suffixIcon,
      this.maxLines = 1,
      this.paddingHorizontal = 20,
      this.readOnly = false,
        this.prefixIcon,
        this.onChange,
        this.callback,
        required this.textAlign})
      : super(key: key);

  GeneralTextField(
      {super.key,
      required this.tfManager,
      this.callback,
      this.prefixIcon,
      this.maxLines = 1,
      this.paddingHorizontal = 0,
      this.readOnly = false,
      this.textAlign = TextAlign.start,
      this.onChange,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: kFieldVerticalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(tfManager.fieldName.isNotEmpty)
          RichText(text: TextSpan(text: tfManager.fieldName,
            style: const TextStyle(color: kTextColor, fontSize: 12, fontWeight: FontWeight.w400),
            children: tfManager.mandatory ? [
              const TextSpan(text: '*', style: TextStyle(color: kRequiredRedColor, fontWeight: FontWeight.bold))
            ] : null,
          ),),
          // Text(tfManager.fieldName, style: const TextStyle(color: kBlackColor, fontSize: 14),),
          Obx(()=> Container(
            width: Get.width,
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.only(left: 8, right: 2),
              // decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(kFieldRadius),
                  // border: Border.all(color: kFieldBorderColor),
                  // color: kFieldBGColor,
              // ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 120),
                        keyboardType: tfManager.keyboardType,
                        maxLines: maxLines,
                        minLines: maxLines>2 ? 3 : null,
                        readOnly: readOnly,
                        maxLength: tfManager.length,
                        controller: tfManager.controller,
                        focusNode: tfManager.focusNode,
                        textCapitalization: tfManager.textCapitalization,
                        textAlign: textAlign,
                        obscureText: _obscure.value,
                        onChanged: (value) {
                          tfManager.validate();
                          if (onChange!=null) {
                            onChange!(value);
                          }
                          if(value.isEmpty && tfManager.errorMessage.isEmpty){
                            callback?.call(value);
                          }
                        },
                      cursorColor: kPrimaryColor,
                        textInputAction: maxLines == 1 ? TextInputAction.done : TextInputAction.newline,
                        inputFormatters: tfManager.formatters,
                        decoration: InputDecoration(
                          labelText: tfManager.hint??tfManager.fieldName,
                          filled: readOnly,
                          fillColor: readOnly ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
                          labelStyle: TextStyle(
                              color: readOnly ? kPrimaryColor : kFieldBorderColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                          ),
                          counterText: '',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(kFieldRadius)),
                            borderSide: BorderSide(color: kFieldBorderColor,width: 1.5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(kFieldRadius)),
                            borderSide: BorderSide(color:  kPrimaryColor, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(kFieldRadius)),
                            borderSide: BorderSide(color: readOnly ? kPrimaryColor : kFieldBorderColor, width: 1),
                          ),
                          // hintText: "Enter ${tfManager.hint??tfManager.fieldName}",
                          contentPadding: const EdgeInsets.all(16),
                          // border: InputBorder.none,
                          prefixIcon: prefixIcon!=null ? Icon(prefixIcon, color: kTextHintColor,size: 32) : null,
                          hintStyle: const TextStyle(color: kTextHintColor),
                          suffixIcon: tfManager.filter != TextFilter.password ? null :
                          GestureDetector(
                              onTap: ()=>_obscure.toggle(),
                              child: Icon(
                                _obscure.isTrue ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
                                color: kTextHintColor,
                              )
                          ),
                        ),
                        style: TextStyle(
                            color: readOnly ? kTextHintColor : kTextColor,
                            decorationColor: kPrimaryColor,
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Visibility(
            visible: tfManager.errorMessage.value.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(tfManager.errorMessage.value, style: const TextStyle(color: kRequiredRedColor, fontSize: 12),),
            ),
          )),
        ],
      ),
    );
  }
}
