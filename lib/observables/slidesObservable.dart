import 'dart:developer';

import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:rxdart/rxdart.dart';

class SlidesBloc {
  List<SlidesInfo>
      slidesInfo; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<List<SlidesInfo>> _subjectSlides;

  SlidesBloc({this.slidesInfo}) {
    _subjectSlides = new BehaviorSubject<List<SlidesInfo>>.seeded(
        this.slidesInfo); //initializes the subject with element already
  }

  Stream<List<SlidesInfo>> get counterObservable => _subjectSlides.stream;

  void updateOrders(List<SlidesInfo> newSlides) {
    List<SlidesInfo> holder = <SlidesInfo>[];
    holder.addAll(this._subjectSlides.value);
    holder.addAll(newSlides);
    _subjectSlides.sink.add(holder);
  }

  void dispose() {
    _subjectSlides.close();
  }
}
