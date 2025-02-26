import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';

class RoutineNotFoundDialog extends StatelessWidget {
  final VoidCallback onTapCancel;
  final VoidCallback onTapRefresh;
  final String title;
  const RoutineNotFoundDialog(
      {Key? key, required this.onTapCancel, required this.onTapRefresh, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: CustomButton(
                onTap: () => onTapCancel(),
                title: "Cancel",
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: CustomButton(
                onTap: () => onTapRefresh(),
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
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
