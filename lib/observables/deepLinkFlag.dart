//Singleton
import 'package:rxdart/rxdart.dart';

class DeepLinkFlag {
  bool flag = false; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<bool> _subjectFlag;



  DeepLinkFlag({this.flag}) {
    _subjectFlag = new BehaviorSubject<bool>.seeded(
        this.flag); //initializes the subject with element already
  }

  Stream<bool> get counterObservable => _subjectFlag.stream;

  void flagOn() {
    _subjectFlag.sink.add(true);
  }

  void dispose() {
    _subjectFlag.close();
  }
}