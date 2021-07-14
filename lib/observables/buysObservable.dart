import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';
import 'package:rxdart/rxdart.dart';

class BuysBloc {
  List<PendingOrder> buys;//if the data is not passed by paramether it initializes with 0
  BehaviorSubject<List<PendingOrder>> _subjectBuys;

  BuysBloc({this.buys}) {
    _subjectBuys = new BehaviorSubject<List<PendingOrder>>.seeded(
        this.buys); //initializes the subject with element already
  }

  Stream<List<PendingOrder>> get bysObservable => _subjectBuys.stream;

  void updateOrders(List<PendingOrder> ordersP) {
    _subjectBuys.sink.add(ordersP);
  }
  void reloadOrders(List<PendingOrder> ordersP) {
    _subjectBuys.value.clear();
    _subjectBuys.sink.add(ordersP);
  }

  void dispose() {
    _subjectBuys.close();
  }
}