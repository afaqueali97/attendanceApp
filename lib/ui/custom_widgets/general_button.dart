import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class GeneralButton extends StatelessWidget {


  final String text;
  final Color textColor;
  final void Function() onPressed;
  final double margin;
  final Color color;
  final double fontSize;
  final double radius;
  final double width;
  final double height;
  final BorderSide borderSide;

  const GeneralButton({Key? key,this.borderSide=BorderSide.none, required this.onPressed, this.text='Submit',this.textColor=Colors.white, this.margin=0, this.color=kButtonColor, this.fontSize = 18.0, this.radius = 10, this.width = 500, this.height = 44}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: margin, vertical: 10),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              side:borderSide,
              borderRadius: BorderRadius.circular(radius)
            )
          ),
          child: Text(text,
            style: TextStyle(
                fontSize: fontSize,
                color:textColor,
                fontWeight: FontWeight.w400
            ),
          )
      ),
    );
  }
}
