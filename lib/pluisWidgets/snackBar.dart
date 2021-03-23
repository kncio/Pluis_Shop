import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// [childWidget] commonly a Text widget
/// [text] information
Future<void> showSnackbar (
    BuildContext context, {
      Widget childWidget,
      String text,
      int timeLimit = 3,
    }) async  {
  assert(childWidget != null || text != null);

  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    useRootNavigator: false,
    barrierColor: Colors.black.withOpacity(0.05),
    transitionDuration: Duration(milliseconds: 800),
    context: context,
    pageBuilder: (_, __, ___) {
      Future.delayed(Duration(seconds: timeLimit), () {
        Navigator.of(context).pop(true);
      });
      return Align(
        alignment: Alignment.bottomCenter,
        child: childWidget ??
            Container(
              height: 50,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 30, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}