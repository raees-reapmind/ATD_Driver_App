import 'dart:io';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String imagePath;
  final String hero;
  final int index;

  const ImageView(
      {Key? key,
      required this.imagePath,
      required this.hero,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$hero$index',
      child: Image.file(
        File(imagePath),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }
}
