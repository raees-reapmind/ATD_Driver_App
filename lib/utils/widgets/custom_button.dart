import 'package:flutter/material.dart';
import '../palette.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color splashColor;
  final VoidCallback onTap;
  final String title;
  final bool isSmall;
  final bool isEnable;


  const CustomButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.backgroundColor = primary500,
    this.textColor = Colors.black,
    this.splashColor = secondary500,
    this.isSmall = false,
    this.isEnable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: isSmall
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        splashColor: splashColor,
        onTap: () => isEnable ? onTap() : () {},
        child: Ink(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: isSmall
                  ? BorderRadius.circular(12)
                  : BorderRadius.circular(20)),
          child: Padding(
            padding: isSmall
                ? const EdgeInsets.only(top: 12, bottom: 12)
                : const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
                child: Text(
              title,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
            )),
          ),
        ),
      ),
    );
  }
}
