import 'package:pluis_hv_app/menuPage/MenuDataModel.dart';
import 'package:rxdart/rxdart.dart';

class CategoryOnDiscountBloc {
  List<CategoryOnDiscountData>
      categoryOndiscount; //if the data is not passed by paramether it initializes with 0
  BehaviorSubject<List<CategoryOnDiscountData>> _subjectOnDiscountCategories;

  CategoryOnDiscountBloc({this.categoryOndiscount}) {
    _subjectOnDiscountCategories =
        new BehaviorSubject<List<CategoryOnDiscountData>>.seeded(this
            .categoryOndiscount); //initializes the subject with element already
  }

  Stream<List<CategoryOnDiscountData>> get categoriesObservable =>
      _subjectOnDiscountCategories.stream;

  void updateCategories(List<CategoryOnDiscountData> newCategoriesOnDiscount) {
    _subjectOnDiscountCategories.sink.add(newCategoriesOnDiscount);
  }

  void dispose() {
    _subjectOnDiscountCategories.close();
  }
}
