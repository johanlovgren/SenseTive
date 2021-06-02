import 'package:flutter/material.dart';

class PlayButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.indigo.shade300.withOpacity(0.7),
      shape: CircleBorder(),
      onPressed: () {
        print('Play button pressed');
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 60.0,
        ),
      ),
    );
  }
}
