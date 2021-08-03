import 'package:pluis_hv_app/detailsPage/detailsPageRemoteDataSource.dart';

import 'package:pluis_hv_app/register/registerDataModel.dart';
import 'package:rxdart/rxdart.dart';

class AviableMunicipesBloc {
  List<Municipe>
      aviableMunicipes; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<List<Municipe>> _subjectMunicipes;

  AviableMunicipesBloc({this.aviableMunicipes}) {
    _subjectMunicipes = new BehaviorSubject<List<Municipe>>.seeded(
        this.aviableMunicipes); //initializes the subject with element already
  }

  Stream<List<Municipe>> get sizesObservable => _subjectMunicipes.stream;

  void updateMunicipes(List<Municipe> newMunicipes) {
    _subjectMunicipes.sink.add(newMunicipes);
  }

  void dispose() {
    // _subjectMunicipes.close();
  }
}
