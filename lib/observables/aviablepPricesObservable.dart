

import 'package:pluis_hv_app/pluisWidgets/pluisProductCard.dart';
import 'package:rxdart/subjects.dart';

class SelectedCurrencyBloc {
  String currency = "";

  BehaviorSubject<String> _subjectCurrency;

  SelectedCurrencyBloc({this.currency}) {
    _subjectCurrency = new BehaviorSubject<String>.seeded(
        this.currency); //initializes the subject with element already
  }

  Stream<String> get currencyObservable => _subjectCurrency.stream;

  void updateVariations(String newCurrency) {
    _subjectCurrency.sink.add(newCurrency);
  }

  void dispose() {
    _subjectCurrency.close();
  }

}