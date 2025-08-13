import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CustomHeadingText extends StatelessWidget {
  final String text;
  final Color headingColor;

  const CustomHeadingText({super.key, required this.text, this.headingColor=kPrimaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20,bottom: 20),
      child: Text(text,textAlign: TextAlign.center, style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color:headingColor ,
        ),
      ),
    );
  }
}