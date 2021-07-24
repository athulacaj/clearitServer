import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatefulWidget {
  final String? image;
  ImageViewScreen({this.image});

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  bool showBackButton = false;
  late Size size;
  @override
  void initState() {
    showBackButton = false;
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.black54,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                showButtonFunction();
              },
              child: Container(
                child: Hero(
                  tag: widget.image!,
                  child: PhotoView(
                    imageProvider: NetworkImage(widget.image!),
                  ),
                ),
              ),
            ),
            showBackButton ? showBackButtonWidget(55) : showBackButtonWidget(0),
          ],
        ));
  }

  Widget showBackButtonWidget(double h) {
    return Positioned(
      top: 0,
      child: AnimatedContainer(
        height: h,
        width: size.width,
        color: Colors.black.withOpacity(0.5),
        duration: Duration(milliseconds: 100),
        child: Row(children: [
          IconButton(
              icon: AnimatedOpacity(
                opacity: showBackButton ? 1 : 0,
                duration: Duration(milliseconds: 100),
                child: Icon(Icons.arrow_back_ios_outlined,
                    color: Colors.white, size: 30),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ]),
      ),
    );
  }

  void showButtonFunction() async {
    showBackButton = true;
    setState(() {});
    await Future.delayed(Duration(milliseconds: 3000));
    showBackButton = false;
    setState(() {});
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
}
