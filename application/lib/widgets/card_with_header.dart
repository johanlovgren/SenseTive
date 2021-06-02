import 'package:flutter/material.dart';

/// Widget used for creating a header row for [CardWithHeaderWidget]
class HeadingRowWidget extends StatelessWidget {
  final String _text;
  final Icon _trailingIcon;
  final Row _startingIcon;


  HeadingRowWidget({
    String text,
    Row startingIcon,
    Icon trailingIcon }) :
        _text = text,
        _trailingIcon = trailingIcon,
        _startingIcon = startingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
            ),
            color: Colors.indigo.shade300,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _startingIcon,
                Text(
                  _text,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                  ),
                ),
                Spacer(),
                _trailingIcon
              ],
            )
        )
    );
  }
}

/// Widget showing a card with a header
///
/// Se also [HeadingRowWidget]
class CardWithHeaderWidget extends StatelessWidget {
  final String _text;
  final Row _startingIcon;
  final Icon _trailingIcon;
  final Widget _child;
  CardWithHeaderWidget({
    String text,
    Widget child,
    Icon startingIcon,
    Icon trailingIcon
  }) :
        this._text = text,
        this._child = child,
        this._startingIcon = startingIcon == null
            ? Row()
            : Row(
          children: [
            startingIcon,
            SizedBox(width: 10.0)
          ],
        ),
        this._trailingIcon = trailingIcon == null ?
        Icon(null) :
        trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 16.0,
          right: 16.0,
          left: 16.0
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  offset: Offset(0,3)
              )
            ]
        ),
        child: Column(
          children: [
            HeadingRowWidget(
              text: _text,
              startingIcon: _startingIcon,
              trailingIcon: _trailingIcon,
            ),
            _child
          ],
        ),
      ),
    );
  }
}