import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';

class FailureDialog extends StatelessWidget {
  final String content;
  const FailureDialog({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomButton(
            onTap: () => Navigator.of(context).pop(),
            title: "Cancel",
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: red500,
                ),
                SizedBox(width: 4),
                Text(
                  'ERROR',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900, color: red500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(content),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
