
import 'package:pluis_hv_app/detailsPage/detailsPageRemoteDataSource.dart';
import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';
import 'package:rxdart/rxdart.dart';

class AviableSizesBloc {
  List<SizeVariationByColor> aviableSizes;//if the data is not passed by paramether it initializes with 0
  BehaviorSubject<List<SizeVariationByColor>> _subjectSizes;

  AviableSizesBloc({this.aviableSizes}) {
    _subjectSizes = new BehaviorSubject<List<SizeVariationByColor>>.seeded(
        this.aviableSizes); //initializes the subject with element already
  }

  Stream<List<SizeVariationByColor>> get sizesObservable => _subjectSizes.stream;

  void updateBills(List<SizeVariationByColor> newSIzes) {
    _subjectSizes.sink.add(newSIzes);
  }

  void dispose() {
    _subjectSizes.close();
  }
}