import 'dart:html';

import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';

class HalfcircleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Arc(
      arcType: ArcType.CONVEX,
      edge: Edge.BOTTOM,
      height: 70.0,
      clipShadows: [
        ClipShadow(
          color: Colors.black,
        )
      ],
      child: new Container(
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo,
      ),
    );
  }
}
