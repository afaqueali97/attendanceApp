
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/custom_widget_controllers/dropdown_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';

class GeneralDropdown extends StatelessWidget {
  final DropdownController controller;
  final double paddingHorizontal;
  final void Function(dynamic)? onItemChanged;
  final RxBool _withShadow = false.obs;
  final bool readOnly;
  // final bool isSearchable;
  final List<dynamic> items = [];

  GeneralDropdown.withBorder({
    super.key,
    required this.controller,
    this.paddingHorizontal = 0,
    this.onItemChanged,
    this.readOnly = false,
    // this.isSearchable = false,
  });

  GeneralDropdown.withShadow({
    super.key,
    required this.controller,
    this.paddingHorizontal = 8,
    this.onItemChanged,
    this.readOnly = false,
    // this.isSearchable = false,
  }) {
    // _withShadow.value=true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal, vertical: kFieldVerticalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: '\t${controller.title}',
              style: const TextStyle(color: kTextColor, fontSize: 12, fontWeight: FontWeight.w400),
              children: controller.mandatory
                  ? [
                      const TextSpan(
                          text: '*',
                          style: TextStyle(
                              color: kRequiredRedColor,
                              fontWeight: FontWeight.bold))
                    ]
                  : null,
            ),
          ),
          // Text(controller.title, style: const TextStyle(color: kTextColor, fontSize: 14),),
          Container(
            width: Get.width,
            padding: EdgeInsets.only(left: _withShadow.isFalse ? 14 : 10, right: 4.0),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(_withShadow.value ? 4 : kFieldRadius),
              border: _withShadow.value
                  ? null
                  : Border.all(color: kFieldBorderColor),
              color: readOnly
                  ? kFieldGreyColor
                  : _withShadow.value
                      ? kWhiteColor
                      : kWhiteColor,
              boxShadow: _withShadow.value
                  ? [
                      const BoxShadow(
                          blurRadius: 3,
                          spreadRadius: 1,
                          color: kFieldShadowColor)
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Obx(
                  () => 
                  // isSearchable? 
                  DropdownSearch(
                          selectedItem: controller.selectedItem.value,
                          enabled: controller.items.isNotEmpty && !readOnly,
                          dropdownBuilder: (context, selectedItem) => Text((controller.selectedItem.value != null) ? controller.selectedItem.value.toString() : controller.hintText.isEmpty ? 'Select ${controller.title}':controller.hintText,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines:1,
                                        style: TextStyle(color: (!readOnly && controller.selectedItem.value == null) ? kGreyColor: kBlackColor)),
                          dropdownButtonProps: DropdownButtonProps(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 40,
                              color: readOnly
                                  ? kLightGreyColor
                                  : controller.items.isEmpty
                                      ? kLightGreyColor
                                      : kTextColor,
                            ),
                          ),
                          items: controller.items,
                          popupProps: PopupProps.menu(
                            showSearchBox: controller.items.length>8,
                            // showSearchBox: isSearchable,
                            fit: FlexFit.loose,
                            itemBuilder: (context, itm, isSelected) {
                              dynamic item = itm;
                              isSelected =item !=null && controller.selectedItem.value!=null && controller.selectedItem.value.id.toString()== item.id.toString();
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                margin: const EdgeInsets.only(bottom: 3, top: 2),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: isSelected ? kPrimaryColor : kWhiteColor,
                                  border: const Border(bottom: BorderSide(color: kFieldGreyColor)),
                                  boxShadow: const [BoxShadow(spreadRadius: 0,blurRadius: 2, color: kFieldShadowColor,offset: Offset(0, 1))]
                                ),
                                child: Text(item.toString(), style: TextStyle(color: isSelected ? kWhiteColor : kTextColor),),
                                );
                            },
                            searchDelay: Duration.zero,
                            scrollbarProps: const ScrollbarProps(
                              scrollbarOrientation: ScrollbarOrientation.right,
                              thumbColor: kPrimaryColor,
                              thickness: 10,
                              radius: Radius.circular(20),
                            ),
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: 'Search ${controller.title}...',
                                hintStyle: const TextStyle(
                                  color: kTextHintColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxHeight: 400,
                              maxWidth: Get.width,
                              minWidth: Get.width,
                            ),
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              border: InputBorder.none,
                              hintText: (readOnly &&controller.selectedItem.value != null)
                                  ? controller.selectedItem.value.toString()
                                  : controller.items.isEmpty ?'${controller.title} not found':controller.hintText.isEmpty ? 'Select ${controller.title}':controller.hintText,
                              hintStyle: const TextStyle(color: kTextHintColor,fontSize: 14,fontWeight: FontWeight.w500),
                            ),
                          ),
                          onChanged: (selectedItem) {
                            controller.selectedItem.value = selectedItem;
                            controller.validate();
                            if (onItemChanged != null) {
                              onItemChanged!(selectedItem);
                            }
                          },
                        )
                      // : DropdownButton(
                      //     value: controller.selectedItem.value,
                      //     isExpanded: true,
                      //     underline: const SizedBox(),
                      //     style: const TextStyle(color: kWhiteColor),
                      //     icon: Icon(Icons.arrow_drop_down,
                      //         size: 40,
                      //         color: readOnly
                      //             ? kLightGreyColor
                      //             : controller.items.isEmpty
                      //                 ? kLightGreyColor
                      //                 : kTextColor),
                      //     iconEnabledColor: kBlackColor,
                      //     items: readOnly
                      //         ? null
                      //         : controller.items
                      //             .map<DropdownMenuItem>((selectedItem) {
                      //             return DropdownMenuItem(
                      //               value: selectedItem,
                      //               child: Text(
                      //                 selectedItem.toString(),
                      //                 overflow: TextOverflow.ellipsis,
                      //                 style: TextStyle(
                      //                     color: readOnly
                      //                         ? kGreyColor
                      //                         : kBlackColor),
                      //               ),
                      //             );
                      //           }).toList(),
                      //     hint: Text(
                      //       (readOnly && controller.selectedItem.value != null)
                      //           ? controller.selectedItem.value.toString()
                      //           : 'Select ${controller.title}',
                      //       style: const TextStyle(
                      //           color: kTextHintColor,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     onChanged: (selectedItem) {
                      //       controller.selectedItem.value = selectedItem;
                      //       controller.validate();
                      //       if (onItemChanged != null) {
                      //         onItemChanged!(selectedItem);
                      //       }
                      //     },
                      //   ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Visibility(
                visible: controller.errorMessage.value.isNotEmpty,
                child: Text(
                  controller.errorMessage.value,
                  style:
                      const TextStyle(color: kRequiredRedColor, fontSize: 12),
                ),
              )),
        ],
      ),
    );
  }
}
