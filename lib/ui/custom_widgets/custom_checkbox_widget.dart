import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/custom_widget_controllers/custom_checkbox_controller.dart';

class CustomCheckbox extends StatelessWidget {
  final CustomCheckboxController controller;

  const CustomCheckbox({
    Key? key, required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        controller.options.length,
            (index) => Obx(
              () => CheckboxListTile(
            title: Text(controller.options[index].title),
            value: controller.selectedOptions.contains(controller.options[index]),
            onChanged: (value) {
              controller.toggleOption(controller.options[index]);
            },
          ),
        ),
      ),
    );
  }
}
