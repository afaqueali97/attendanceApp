import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/text_field_manager.dart';
import '../../utils/app_colors.dart';

class CustomTrackTextField extends StatelessWidget {
  final TextFieldManager textFieldManager;
  final double paddingHorizontal;
  final ValueChanged<String>? onChange;
  final bool useMaterial ;
  const CustomTrackTextField({super.key, required this.textFieldManager, this.paddingHorizontal = 10, this.onChange, this.useMaterial = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Track Your Road Permit / MVI License / Certificate', style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w500, fontSize: 11),),
        Container(
          width: Get.width,
          margin:  EdgeInsets.only(bottom: 8, top: 4, right: paddingHorizontal, left: paddingHorizontal),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  elevation: useMaterial ? 1 : 0,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10),),
                  child: TextField(
                    cursorColor: kPrimaryColor,
                    controller: textFieldManager.controller,
                    focusNode: textFieldManager.focusNode,
                    onChanged: (value){
                      if (onChange!=null) {
                        onChange!(value);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: textFieldManager.hint,
                      filled: !useMaterial,
                      fillColor: !useMaterial ? kGreyColor.withAlpha(40) : null,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: useMaterial ? 50 : 48,
                  width: 55,
                  decoration: const BoxDecoration(
                    color: kYellowColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/icons/search.png"),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/validate.png", height: 20,),
            const Text(" Validate", style: TextStyle(fontSize: 14, color: kGreyColor),),
            const SizedBox(width: 40,),
            Image.asset("assets/icons/not-validate.png", height: 20,),
            const Text(" Not Validate", style: TextStyle(fontSize: 14, color: kGreyColor),)
          ],
        ),
      ],
    );
  }
}
