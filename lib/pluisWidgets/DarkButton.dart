import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DarkButton extends StatelessWidget {
  final String text;
  final Function action;

  const DarkButton({
    Key key,
    this.text,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.all(16),
      onPressed: action,
      color: Colors.black,
      child: Center(
        child: Text(
          this.text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
