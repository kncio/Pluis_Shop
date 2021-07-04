import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/argsClasses.dart';
import 'package:pluis_hv_app/commons/pagesRoutes.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';

import 'package:pluis_hv_app/detailsPage/detailsPage.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageCubit.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageCubit.dart';
import 'package:pluis_hv_app/observables/aviablepPricesObservable.dart';
import 'package:pluis_hv_app/pluisWidgets/homeBottomBar.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCard.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCardCubit.dart';
import 'package:pluis_hv_app/shopCart/shopCartRemoteDataSource.dart';

import '../injectorContainer.dart' as injectionContainer;
import 'galleryPageState.dart';

class GalleryPage extends StatefulWidget {
  final GalleryArgs categoryInfo;

  const GalleryPage({Key key, this.categoryInfo}) : super(key: key);

  @override
  _GalleryPage createState() {
    return _GalleryPage(categoryInfo: this.categoryInfo);
  }
}

class _GalleryPage extends State<GalleryPage> {
  final GalleryArgs categoryInfo;

  //currencys
  List<SiteCurrency> currencys = [];
  int selectedCurrency = 0;
  SelectedCurrencyBloc _selectedCurrencyBloc =
      SelectedCurrencyBloc(currency: "");

  _GalleryPage({this.categoryInfo});

  @override
  void initState() {
    context.read<GalleryPageCubit>().getSiteCurrencys().then((value) => {
          if (this.categoryInfo.categoryId != null)
            {
              this.currencys = value,
              if (this.currencys.length > 0)
                {
                  this._selectedCurrencyBloc.updateVariations(
                      this.currencys[this.selectedCurrency].coin_nomenclature),
                },
              context.read<GalleryPageCubit>().getProductsByCategory(
                  this.categoryInfo.categoryId, this.categoryInfo.discountOnly)
            }
          else
            {
              log("crazy"),
              context.read<GalleryPageCubit>().getAllProducts(
                  this.categoryInfo.discountOnly, this.categoryInfo.genderId)
            }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: buildBody(),
      bottomNavigationBar: BottomBar(
        onPressBookmark: () =>
            Navigator.of(context).pushNamed(ADDRESS_BOOK_ROUTE),
        onPressSearch: () => Navigator.of(context)
            .pushNamedAndRemoveUntil(HOME_PAGE_ROUTE, ModalRoute.withName('/')),
        onPressShopBag: () => Navigator.of(context).pushNamed(SHOP_CART),
        onPressAccount: () => Navigator.of(context).pushNamed(LOGIN_PAGE_ROUTE),
        onPressMenu: () => Navigator.of(context).pushNamed(MENU_PAGE),
      ),
    );
  }

  Widget buildBody() {
    return BlocConsumer<GalleryPageCubit, GalleryPageState>(
        listener: (context, state) async {
          if (state is GalleryPageSuccessState) {
            setState(() {
              this.currencys;
            });
            log(state.products.toString());
          } else if (state is GalleryPageErrorState) {
            log("Errror: => " + state.message);
          }
        },
        buildWhen: (previous, current) =>
            current is GalleryPageSuccessState ||
            previous is GalleryPageLoadingState,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container(child: buildGridView(context, state)))
            ],
          );
        });
  }

  GridView buildGridView(BuildContext context, GalleryPageState state) {
    if (state is GalleryPageSuccessState && state.products != null) {
      return GridView.builder(
        itemCount: state.products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          childAspectRatio: 0.60,
        ),
        itemBuilder: (context, index) => BlocProvider<ProductCardCubit>(
          create: (_) => new ProductCardCubit(
              repository: injectionContainer.sl<ProductCardRepository>()),
          child: ProductCard(
            currencyBloc: this._selectedCurrencyBloc,
            product: state.products[index],
            press: () => Navigator.push(
                context,
                PLuisPageRoute(
                    builder: (_) => BlocProvider<DetailsCubit>(
                          create: (_) => injectionContainer.sl<DetailsCubit>(),
                          child: DetailsPage(
                            product: state.products[index],
                            selectedCurrencyNomenclature: this
                                .currencys[this.selectedCurrency]
                                .coin_nomenclature,
                          ),
                        ))),
          ),
        ),
      );
    }
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.black,
        onPressed: () => {Navigator.pop(context)},
      ),
      title: Padding(
          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
          child: Text(
              this.categoryInfo != null ? this.categoryInfo.name : "TODOS",
              style: TextStyle(color: Colors.black))),
      actions: <Widget>[
        (this.currencys.length > 0)
            ? Padding(
                padding: EdgeInsets.fromLTRB(32, 8, 32, 0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        this.selectedCurrency =
                            (this.selectedCurrency + 1) % this.currencys.length;
                        _selectedCurrencyBloc.updateVariations(this
                            .currencys[this.selectedCurrency]
                            .coin_nomenclature);
                      });
                    },
                    child: Container(
                      child: Text(
                        this
                            .currencys[this.selectedCurrency]
                            .coin_nomenclature
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}
