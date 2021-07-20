import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/addressBook/addressBookCubit.dart';
import 'package:pluis_hv_app/addressBook/addressBookPage.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/argsClasses.dart';
import 'package:pluis_hv_app/commons/deepLinksBloc.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/pocWidget.dart';
import 'package:pluis_hv_app/detailsPage/detailsPage.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageCubit.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageCubit.dart';
import 'package:pluis_hv_app/homePage/homePage.dart';
import 'package:pluis_hv_app/homePage/homePageCubit.dart';
import 'package:pluis_hv_app/loginPage/loginPage.dart';
import 'package:pluis_hv_app/menuPage/menuPage.dart';
import 'package:pluis_hv_app/register/registerCubit.dart';
import 'package:pluis_hv_app/register/registerPage.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:pluis_hv_app/shopCart/shopCart.dart';
import 'package:pluis_hv_app/shopCart/shopCartCubit.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenCubit.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenPage.dart';
import 'package:provider/provider.dart';

import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;
import 'commons/pagesRoutes.dart';
import 'galleryPage/galleryPage.dart';
import 'injectorContainer.dart' as injectionContainer;
import 'loginPage/loginCubit.dart';
import 'menuPage/menuCubit.dart';

class PluisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tienda Pluis',
      theme: PluisAppTheme.themeDataLight,
      home: BlocProvider<SplashScreenCubit>(
        create: (_) => injectionContainer.sl<SplashScreenCubit>(),
        child: SplashScreenPage(),
      ),
      onGenerateRoute: (settings) {
        log(settings.name);
        if (_deepLinkValidator(settings.name)) {
          //Notify entry for deeplink
          Settings.setEntryType(true);

          // return PLuisPageRoute(
          //     builder: (_) => BlocProvider<DetailsCubit>(
          //       create: (_) => injectionContainer.sl<DetailsCubit>(),
          //       child: DetailsPage(
          //         product: null,
          //         selectedCurrencyNomenclature: 'USD'
          //       ),
          //     ));
          return PLuisPageRoute(
            settings: RouteSettings(name: "/home/product"),
            builder: (_) => Scaffold(
              body: Container(
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                              'POR LAS GENERATED RUTES SE METIO ${settings.name}',
                              style: Theme.of(context).textTheme.title)))),
            ),
          );
        }
        switch (settings.name) {
          case GALERY_SCREEN_PAGE_ROUTE:
            return PLuisPageRoute(
                builder: (_) => BlocProvider<GalleryPageCubit>(
                    create: (_) => injectionContainer.sl<GalleryPageCubit>(),
                    child: GalleryPage(
                        categoryInfo: (settings.arguments as GalleryArgs))));
          case ADDRESS_BOOK_ROUTE:
            return PLuisPageRoute(
                builder: (_) => BlocProvider<AddressBookCubit>(
                    create: (_) => injectionContainer.sl<AddressBookCubit>(),
                    child: AddressBookPage()));
          case REGISTER_PAGE_ROUTE:
            return PLuisPageRoute(
                builder: (_) => BlocProvider<RegisterCubit>(
                      create: (_) => injectionContainer.sl<RegisterCubit>(),
                      child: RegisterPage(),
                    ));
          case SHOP_CART:
            return PLuisPageRoute(
                builder: (_) => BlocProvider(
                      create: (_) => injectionContainer.sl<ShopCartCubit>(),
                      child: ShopCartPage(),
                    ));
          case LOGIN_PAGE_ROUTE:
            return PLuisPageRoute(
              builder: (_) => BlocProvider(
                  create: (_) => injectionContainer.sl<LoginCubit>(),
                  child: LoginPage()),
            );
          case MENU_PAGE:
            return PLuisPageRoute(
              builder: (_) => BlocProvider(
                  create: (_) => injectionContainer.sl<MenuCubit>(),
                  child: MenuPage()),
            );
          case HOME_PAGE_ROUTE:
            log("ENTRO POR LAS RUTAS ");
            return PLuisPageRoute(
                builder: (_) => BlocProvider<HomePageCubit>(
                      create: (_) => injectionContainer.sl<HomePageCubit>(),
                      child: HomePage(),
                    ));
          default:
            return PLuisPageRoute(
              builder: (_) => Scaffold(
                body: Container(
                    child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('BAD LINK',
                                style: Theme.of(context).textTheme.title)))),
              ),
            );
        }
      },
    );
  }

  bool _deepLinkValidator(String route) {
    var routeName = route.split("?");
    if (routeName[0] == "/product") {
      var parsedUri = Uri.tryParse(route);
      if (parsedUri != null) {
        log(parsedUri.queryParameters.keys.toString());
        return parsedUri.queryParameters.keys.length == 2 &&
            parsedUri.queryParameters.keys.toList()[0] == 'id' &&
            parsedUri.queryParameters.keys.toList()[1] == 'coin';
      }
    }

    return false;
  }
}
