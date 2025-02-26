import 'dart:io';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:flutter/material.dart';

import 'image_full_screen_view.dart';

class ImageListView extends StatelessWidget {
  final List<ImageDetails> imageList;
  final String heroTag;
  const ImageListView(
      {Key? key, required this.imageList, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.maxFinite,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImageView(
                    imagePath: imageList[index].imagePath!,
                    hero: '$heroTag$index',
                    index: index,
                  ),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Hero(
                      tag: "$heroTag$index",
                      child: Image.file(
                        File(imageList[index].imagePath!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )),
    );
  }
}
