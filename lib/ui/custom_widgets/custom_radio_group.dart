import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../controllers/custom_widget_controllers/custom_radio_button_controller.dart';
import '../../models/item_model.dart';

class RadioButtonGroup extends StatelessWidget {

  final List<ItemModel> options;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final CustomRadioButtonController controller;

  const RadioButtonGroup({
    Key? key,
    required this.options,
    required this.controller,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.crossAxisAlignment = CrossAxisAlignment.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        const SizedBox(height: 15),
        Column(
          children: options.map((option) {
            return Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                if (mainAxisAlignment == MainAxisAlignment.end)
                  Text(option.title, style: GoogleFonts.notoNastaliqUrdu(fontWeight: FontWeight.bold, fontSize: 18,),),
                Obx(() => Radio<ItemModel>(
                  value: option,
                  groupValue: controller.selectedValue.value,
                  onChanged: (value) {
                    controller.setSelectedValue(value);
                  },
                )),
                if (mainAxisAlignment != MainAxisAlignment.end)
                  Text(
                    option.title,
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            );
          }).toList(),
        ),
        Obx(() => Visibility(
          visible: controller.errorMessage.value.isNotEmpty,
          child:
          Text(
            controller.errorMessage.value, style: const TextStyle(color: kRequiredRedColor,fontSize: 13),),
        )),
        const SizedBox(height: 10,)
      ],
    );
  }
}
