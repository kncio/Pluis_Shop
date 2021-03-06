
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class LogoImage extends StatelessWidget {
  const LogoImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width/4,
        height: MediaQuery.of(context).size.height * 3 / 13,
        // height: MediaQuery.of(context).size.height * 2 / 13,
        child: Image.asset(
          'assets/logo/icon.png',
          fit: BoxFit.fitWidth,

        ),
      ),
    );
  }
}
