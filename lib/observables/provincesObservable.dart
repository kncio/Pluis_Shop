

import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:rxdart/rxdart.dart';

class AviableProvincesBloc {
  List<Province>
  aviableProvinces; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<List<Province>> _subjectProvinces;

  AviableProvincesBloc({this.aviableProvinces}) {
    _subjectProvinces = new BehaviorSubject<List<Province>>.seeded(
        this.aviableProvinces); //initializes the subject with element already
  }

  Stream<List<Province>> get provincesObservable => _subjectProvinces.stream;

  void updateProvinces(List<Province> newProvinces) {
    aviableProvinces.clear();
    _subjectProvinces.sink.add(newProvinces);
  }

  void dispose() {
    // _subjectMunicipes.close();
  }
}