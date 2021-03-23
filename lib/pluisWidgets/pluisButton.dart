


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/values.dart';

class PLuisButton extends StatelessWidget{

  final Function press;
  final String label;

  const PLuisButton({Key key, this.press, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, DEFAULT_PADDING, 0),
        child: GestureDetector(
          onTap: this.press
          ,
          child: DecoratedBox(
            child: SizedBox(
              height: 40,
              width: 100,
              child: Center(
                  child: Text(
                    this.label,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black)),
          ),
        ));
  }

}