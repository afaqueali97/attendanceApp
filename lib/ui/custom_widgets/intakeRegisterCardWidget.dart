import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

Widget intakeListCard({required String name, required String cnic, required String phone, required String city, bool viewEditButton = false, Function()? onPressedView}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: kWhiteColor,
      boxShadow: const [
        BoxShadow(blurRadius: 3, spreadRadius: 1, color: kFieldShadowColor)
      ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: kTextColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(cnic,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: kDarkGreyColor),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Text(
                phone,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: kTextColor),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.center,
                padding:
                const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                    color: kButtonColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 5),
                  child: Text(
                    city,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: kWhiteColor,
                        height: 1.2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onPressedView,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Image.asset('assets/icons/view-icon.png', width: 20),
          ),
        ),
      ],
    ),
  );
}

