import 'package:flutter/material.dart';


class SecondaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final double height;
  final double? width;
  final double? borderRadius;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;

  static const double defaultBorderRadius = 9;

  const SecondaryButton({
    required this.text,
    required this.onPressed,
    this.height = 15,
    this.width,
    this.buttonColor = Colors.green,
    this.textColor=Colors.white,
    this.borderRadius = 10,
    this.borderColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: height),
          side: BorderSide(color: borderColor!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? defaultBorderRadius),
          ),
        ),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
