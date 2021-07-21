import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/detailsPage/detailsPage.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageCubit.dart';
import 'package:pluis_hv_app/observables/deepLinkFlag.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenCubit.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenPage.dart';
import 'package:provider/provider.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectionContainer;
import 'deepLinksBloc.dart';

import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class PocWidget extends StatelessWidget {
  final String coin;
  final String rowId;
  final String image;

  Product _product;

  PocWidget({
    Key key,
    this.coin,
    this.rowId,
    this.image,
  }) : super(key: key) {
    injectionContainer.sl<DetailsCubit>().getProductDetail(this.rowId).then(
        (value) => {
              _product = value,
              log("termino el constructor" + this._product.price)
            });
  }

  @override
  Widget build(BuildContext context) {
    //DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);//
    var _bloc = injectorContainer.sl<DeepLinkFlag>();

    log("building");
    return StreamBuilder<bool>(
      stream: _bloc.counterObservable,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data ) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          log(this._product.price + this._product.row_id);

          return BlocProvider<DetailsCubit>(
            create: (_) => injectionContainer.sl<DetailsCubit>(),
            child: DetailsPage(
              product: _product,
              selectedCurrencyNomenclature: coin,
            ),
          );
        }
      },
    );
  }
}
