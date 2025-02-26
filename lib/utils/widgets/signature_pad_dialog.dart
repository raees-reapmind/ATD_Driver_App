import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class SignaturePadDialog extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final GlobalKey<SignatureState> signState;
  final VoidCallback onTapSave;
  const SignaturePadDialog({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.signState,
    required this.onTapSave,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: CustomButton(
                onTap: () => Navigator.of(context).pop(),
                title: "Cancel",
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: CustomButton(
                onTap: () => onTapSave(),
                title: "Save",
                backgroundColor: secondary500,
                textColor: Colors.white,
                splashColor: primary500,
              ))
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
              isCaps: false, controller: controller, hintText: hintText),
          const SizedBox(height: 10),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: white300,
              ),
              height: 0.6 * size.width,
              child: Signature(
                key: signState,
                color: secondary500,
                strokeWidth: 4,
              )),
        ],
      ),
    );
  }
}
