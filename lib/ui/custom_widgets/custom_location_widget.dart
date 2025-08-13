import 'package:flutter/material.dart';
import '../../controllers/custom_widget_controllers/custom_location_controller.dart';
import '../../utils/app_colors.dart';
import 'general_text_field.dart';

class CustomLocationWidget extends StatelessWidget {
  final CustomLocationController controller;
  const CustomLocationWidget({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: GeneralTextField.withBorder(tfManager: controller.locationTfManager, readOnly: true, textAlign: TextAlign.left,)),
        const SizedBox(width: 5,),
        Container(
            width: 45,
            // height: 50,
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () {
               controller.onLoadLocation();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: kPrimaryColor.withOpacity(0.9),
                padding: const EdgeInsets.all(10),
              ),
              child: Image.asset('assets/images/load_location.png', color: kWhiteColor,fit: BoxFit.fill,),
            ),
          ),
      ],
    );
  }
}
