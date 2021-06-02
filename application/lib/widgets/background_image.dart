import 'package:flutter/material.dart';
import 'dart:ui';

class BackgroundImage extends StatelessWidget {
  final String imagePath;
  const BackgroundImage({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(imagePath)
          )
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        ),
      ),
    );
  }
}
