import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  final VoidCallback onTap;
  const CameraButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: secondary500,
        child: InkWell(
          onTap: () => onTap(),
          splashColor: primary500,
          child: Ink(
            height: 55,
            width: 55,
            child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  Icons.receipt_long,
                  color: white500,
                )),
          ),
        ),
      ),
    );
  }
}
