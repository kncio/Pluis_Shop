import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/argsClasses.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<MenuCategoriesExpandableCubit>()
        .getCategoryByGender(this.genreId);
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
                      GestureDetector(
                        onTap: () => {
                          Navigator.pushNamed(context, GALERY_SCREEN_PAGE_ROUTE,
                              arguments: GalleryArgs(
                                  categoryId: null,
                                  name: "REBAJAS",
                                  discountOnly: true,
                                  genderId: this.genreId))
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 30, 0, 30),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "REBAJAS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                        ),
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
