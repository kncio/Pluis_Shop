import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';
import 'package:rxdart/rxdart.dart';

class BillsBloc {
  List<BillData> bills;//if the data is not passed by paramether it initializes with 0
  BehaviorSubject<List<BillData>> _subjectBills;

  BillsBloc({this.bills}) {
    _subjectBills = new BehaviorSubject<List<BillData>>.seeded(
        this.bills); //initializes the subject with element already
  }

  Stream<List<BillData>> get billsObservable => _subjectBills.stream;

  void updateBills(List<BillData> newBills) {
    _subjectBills.sink.add(newBills);
  }

  void dispose() {
    _subjectBills.close();
  }
}