
import 'package:pluis_hv_app/loginPage/loginRemoteDatasource.dart';
import 'package:rxdart/rxdart.dart';

class PendingOrdersBloc {
  List<PendingOrder> pendingOrders;//if the data is not passed by paramether it initializes with 0
  BehaviorSubject<List<PendingOrder>> _subjectCounter;

  PendingOrdersBloc({this.pendingOrders}) {
    _subjectCounter = new BehaviorSubject<List<PendingOrder>>.seeded(
        this.pendingOrders); //initializes the subject with element already
  }

  Stream<List<PendingOrder>> get counterObservable => _subjectCounter.stream;

  void updateOrders(List<PendingOrder> ordersP) {
    _subjectCounter.sink.add(ordersP);
  }

  void dispose() {
    _subjectCounter.close();
  }
}