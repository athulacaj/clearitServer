import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  final String image;
  ImageViewScreen({this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: Container(
          child: Hero(
            tag: image,
            child: PhotoView(
              imageProvider: NetworkImage(image),
            ),
          ),
        ));
  }
}
