import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key,required this.image}) : super(key: key);
  final List<String> image;

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: PageView(
          controller: PageController(
            initialPage: 0,
          ),
          scrollDirection: Axis.horizontal,
          pageSnapping: true,
          children: widget.image
              .map(
                (item) => Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(item), fit: BoxFit.cover),
                ),
              ),
            ),
          )
              .toList()),
    );;
  }
}
