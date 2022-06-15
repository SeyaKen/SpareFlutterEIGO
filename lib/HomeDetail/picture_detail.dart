import 'package:flutter/material.dart';

class PictureDetail extends StatelessWidget {
  PictureDetail({Key? key, required this.pictureURL}) : super(key: key);
  String pictureURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
          ),
          Image.network(
            pictureURL,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
