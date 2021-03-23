import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(70, 45, 0, 0),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  'HOMBRE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                )),
            Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  'MUJER',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                )),
            Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  'INFANTE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
