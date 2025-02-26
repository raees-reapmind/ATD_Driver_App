import 'package:flutter/material.dart';

class TitleContent extends StatelessWidget {
  final String title;
  final String content;
  final bool isBold;
  const TitleContent({
    Key? key,
    required this.title,
    required this.content,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Text(
              textAlign: TextAlign.end,
              content,
              style: isBold
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}
