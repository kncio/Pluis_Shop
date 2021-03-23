import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/commons/appTheme.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageCubit.dart';
import 'package:pluis_hv_app/homePage/homePage.dart';
import 'package:pluis_hv_app/homePage/homePageCubit.dart';
import 'package:pluis_hv_app/loginPage/loginPage.dart';
import 'package:pluis_hv_app/menuPage/menuPage.dart';
import 'package:pluis_hv_app/register/registerCubit.dart';
import 'package:pluis_hv_app/register/registerPage.dart';
import 'package:pluis_hv_app/shopCart/shopCart.dart';
import 'package:pluis_hv_app/shopCart/shopCartCubit.dart';

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
      home: BlocProvider<HomePageCubit>(
        create: (_) => injectionContainer.sl<HomePageCubit>(),
        child: HomePage(),
        //   home: ShopCartPage(),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case GALERY_SCREEN_PAGE_ROUTE:
            return PLuisPageRoute(
                builder: (_) =>
                    BlocProvider<GalleryPageCubit>(
                      create: (_) => injectionContainer.sl<GalleryPageCubit>(),
                      child: GalleryPage(),
                    ));
          case REGISTER_PAGE_ROUTE:
            return PLuisPageRoute(
                builder: (_) =>
                    BlocProvider<RegisterCubit>(
                      create: (_) => injectionContainer.sl<RegisterCubit>(),
                      child: RegisterPage(),
                    ));
          case SHOP_CART:
            return PLuisPageRoute(
                builder: (_) =>
                    BlocProvider(
                      create: (_) => injectionContainer.sl<ShopCartCubit>(),
                      child: ShopCartPage(),
                    ));
          case LOGIN_PAGE_ROUTE:
            return PLuisPageRoute(
              builder: (_) =>
                  BlocProvider(
                      create: (_) => injectionContainer.sl<LoginCubit>(),
                      child: LoginPage()),
            );
          case MENU_PAGE:
            return PLuisPageRoute(
              builder: (_) =>
                  BlocProvider(
                      create: (_) => injectionContainer.sl<MenuCubit>(),
                      child: MenuPage()),
            );
          default:
            return PLuisPageRoute(
                builder: (_) =>
                    BlocProvider<HomePageCubit>(
                      create: (_) => injectionContainer.sl<HomePageCubit>(),
                      child: HomePage(),
                    )
            );
        }
      },
    );
  }
}
