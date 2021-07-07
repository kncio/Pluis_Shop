import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/argsClasses.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/observables/CategoryOnDiscountObservable.dart';
import 'package:pluis_hv_app/pluisWidgets/expandableRow.dart';

import 'MenuDataModel.dart';
import 'MenuRepository.dart';

class MenuCategoriesExpandable extends StatefulWidget {
  final String genreId;

  const MenuCategoriesExpandable({Key key, this.genreId}) : super(key: key);

  @override
  _MenuCategoriesExpandable createState() {
    return _MenuCategoriesExpandable(genreId: this.genreId);
  }
}

class _MenuCategoriesExpandable extends State<MenuCategoriesExpandable> {
  final String genreId;

  _MenuCategoriesExpandable({this.genreId});

  CategoryOnDiscountBloc _categoriesOnDiscountBloc =
      CategoryOnDiscountBloc(categoryOndiscount: <CategoryOnDiscountData>[]);

  @override
  void initState() {
    super.initState();
    context
        .read<MenuCategoriesExpandableCubit>()
        .getCategoryByGender(this.genreId);
    context
        .read<MenuCategoriesExpandableCubit>()
        .getCategoryOnDiscountByGender(this.genreId)
        .then((categoryList) =>
            {this._categoriesOnDiscountBloc.updateCategories(categoryList)});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuCategoriesExpandableCubit,
            MenuCategoriesExpandableState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case MenuCategoriesExpandableSuccess:
              return ListView(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: StreamBuilder(
                            stream: this
                                ._categoriesOnDiscountBloc
                                .categoriesObservable,
                            builder: (context,
                                AsyncSnapshot<List<CategoryOnDiscountData>>
                                    snapshot) {
                              return (snapshot.data != null &&
                                      snapshot.data.length > 0)
                                  ? ExpandableRow(
                                      headerName: "REBAJAS",
                                      itemsNames: (snapshot.data != null)
                                          ? List<Map<String, dynamic>>.from(
                                              snapshot.data
                                                  .map((e) => e.toMap()))
                                          : [],
                                    )
                                  : SizedBox.shrink();
                            }),
                      ),
                      ExpandableRow(
                        headerName: "COLECCIONES",
                        itemsNames: List<Map<String, dynamic>>.from(
                            (state as MenuCategoriesExpandableSuccess)
                                .categories
                                .map((e) => e.toMap())),
                      ),
                    ],
                  ),
                )
              ]);
            default:
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              );
          }
        },
        listener: (context, state) async {});
  }
}

class MenuCategoriesExpandableCubit
    extends Cubit<MenuCategoriesExpandableState> {
  final MenuPageRepository repository;

  MenuCategoriesExpandableCubit({this.repository})
      : super(MenuCategoriesExpandableInitial());

  Future<void> getCategoryByGender(String genderId) async {
    emit(MenuCategoriesExpandableLoading());
    var eitherValue = await repository.getCategoryByGender(genderId);
    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(MenuCategoriesExpandableError("Server Unreachable"))
            : emit(MenuCategoriesExpandableError(failure.properties.first)),
        (categories) => categories != null
            ? emit(MenuCategoriesExpandableSuccess(categories: categories))
            : emit(MenuCategoriesExpandableError("Error desconocido")));
  }

  Future<List<CategoryOnDiscountData>> getCategoryOnDiscountByGender(
      String genderId) async {
    var returnList = <CategoryOnDiscountData>[];

    var eitherValue = await repository.getCategoryOnDiscountByGender(genderId);
    eitherValue.fold(
        (failure) => failure.properties.isEmpty
            ? emit(MenuCategoriesExpandableError("Server Unreachable"))
            : emit(MenuCategoriesExpandableError(failure.properties.first)),
        (categoriesOnDiscount) => categoriesOnDiscount != null
            ? returnList = categoriesOnDiscount
            : emit(MenuCategoriesExpandableError("Error desconocido")));

    return returnList;
  }
}

abstract class MenuCategoriesExpandableState extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuCategoriesExpandableInitial extends MenuCategoriesExpandableState {}

class MenuCategoriesExpandableLoading extends MenuCategoriesExpandableState {}

class MenuCategoriesExpandableError extends MenuCategoriesExpandableState {
  final String message;

  MenuCategoriesExpandableError(this.message);
}

class MenuCategoriesExpandableSuccess extends MenuCategoriesExpandableState {
  final List<CategoryData> categories;

  MenuCategoriesExpandableSuccess({this.categories});
}
