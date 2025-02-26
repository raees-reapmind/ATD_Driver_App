import 'package:flutter/material.dart';

import '../../../../utils/palette.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color splashColor;
  final VoidCallback onTap;
  final String title;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.backgroundColor = primary500,
    this.textColor = Colors.black,
    this.splashColor = secondary500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        splashColor: splashColor,
        onTap: () => onTap(),
        child: Ink(
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
                child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
            )),
          ),
        ),
      ),
    );
  }
}
