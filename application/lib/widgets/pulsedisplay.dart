import 'package:flutter/material.dart';

class PulseDisplayWidget extends StatelessWidget {
  final int _heartRate;

  PulseDisplayWidget(this._heartRate);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        Icon(Icons.favorite, size: 120, color: Colors.red),
        Text(
          '$_heartRate\nBPM',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
