import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';

class SignatureButton extends StatelessWidget {
  final VoidCallback onTap;
  const SignatureButton({Key? key, required this.onTap}) : super(key: key);

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
              child: ImageIcon(
                AssetImage(
                  '$imagesPath/icons/sign_icon.png',
                ),
                color: white500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
