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
import 'package:pluis_hv_app/commons/productsModel.dart';
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
      // home: BlocProvider<SplashScreenCubit>(
      //   create: (_) => injectionContainer.sl<SplashScreenCubit>(),
      //   child: SplashScreenPage(),
      // ),
      onGenerateRoute: (settings) {
        log("ROUTE :" + settings.name);
        if (_deepLinkValidator(settings.name)) {
          //Notify entry for deeplink
          Settings.setEntryType(true);
          var rowId = Uri.parse(settings.name).queryParameters['id'];
          var coin = Uri.parse(settings.name).queryParameters['coin'];
          var image = Uri.parse(settings.name).queryParameters['image'];
          return PLuisPageRoute(builder: (_) => PocWidget(coin: coin,rowId: rowId,image: image,));
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
            return PLuisPageRoute(
                builder: (_) => BlocProvider<HomePageCubit>(
                      create: (_) => injectionContainer.sl<HomePageCubit>(),
                      child: HomePage(),
                    ));
          default:
            return PLuisPageRoute(
              builder: (_) => BlocProvider<SplashScreenCubit>(
                create: (_) => injectionContainer.sl<SplashScreenCubit>(),
                child: SplashScreenPage(),
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
        return parsedUri.queryParameters.keys.length == 3 &&
            parsedUri.queryParameters.keys.contains('id') &&
            parsedUri.queryParameters.keys.contains('coin') &&
            parsedUri.queryParameters.keys.contains('image');
      }
    }

    return false;
  }
}
