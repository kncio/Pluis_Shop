import 'dart:developer';

import 'package:rxdart/rxdart.dart';

//Singleton
class ColorBloc {
  int color = 0; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<int> _subjectColor;
  String colorsString;

  ColorBloc({this.colorsString}) {
    var hexC = hexColor("#000000");
    this.color = hexC;

    if (this.colorsString.contains("#")) {
      hexC = hexColor(colorsString);
      this.color = hexC;
    }

    _subjectColor = new BehaviorSubject<int>.seeded(
        this.color); //initializes the subject with element already
  }

  Stream<int> get colorObservable => _subjectColor.stream;

  void updateColor(String newColorString) {
    if(!newColorString.contains('#')){
      newColorString = "#000000";
    }
    var hexC = hexColor(newColorString);
    _subjectColor.sink.add(hexC);
  }

  void dispose() {
    _subjectColor.close();
  }

  int hexColor(String colorCodeString) {
    String xFormat = "0xff" + colorCodeString;
    xFormat = xFormat.replaceAll('#', '');
    int xIntFormat = int.parse(xFormat);
    return xIntFormat;
  }
}
