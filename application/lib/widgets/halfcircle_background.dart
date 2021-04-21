import 'dart:html';

import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';

class HalfcircleWidget extends StatelessWidget {
  final bool _isMeasuring;

  HalfcircleWidget(this._isMeasuring);

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
        height: !_isMeasuring
            ? MediaQuery.of(context).size.height * 0.4
            : MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo,
      ),
    );
  }
}
