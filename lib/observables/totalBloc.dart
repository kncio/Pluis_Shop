import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

//Singleton
class TotalBloc {
  double sum =
      0; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<double> _subjectCounter;

  final ShoppingCart shoppingCartReference;

  TotalBloc({this.sum, this.shoppingCartReference}) {
    _subjectCounter = new BehaviorSubject<double>.seeded(
        this.sum); //initializes the subject with element already
  }

  Stream<double> get counterObservable => _subjectCounter.stream;

  void updateTotal() {
    sum = 0;
    this.shoppingCartReference.shoppingList.forEach((product) {
      sum += double.tryParse(product.productData.price) * product.qty;
    });

    _subjectCounter.sink.add(sum);
  }

  void dispose() {
    _subjectCounter.close();
  }
}
