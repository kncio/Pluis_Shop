import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pluis_hv_app/addressBook/addressBookCubit.dart';
import 'package:pluis_hv_app/addressBook/addressBookRepository.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageCubit.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageRepository.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageCubit.dart';
import 'package:pluis_hv_app/galleryPage/galleryRepository.dart';
import 'package:pluis_hv_app/homePage/homePageCubit.dart';
import 'package:pluis_hv_app/homePage/homePageRepository.dart';
import 'package:pluis_hv_app/loginPage/loginCubit.dart';
import 'package:pluis_hv_app/loginPage/loginRepository.dart';
import 'package:pluis_hv_app/menuPage/MenuRepository.dart';
import 'package:pluis_hv_app/menuPage/categoryExpandable.dart';
import 'package:pluis_hv_app/menuPage/menuCubit.dart';
import 'package:pluis_hv_app/observables/colorStringObservable.dart';
import 'package:pluis_hv_app/observables/totalBloc.dart';
import 'package:pluis_hv_app/pluisWidgets/homePageCarousel.dart';
import 'package:pluis_hv_app/pluisWidgets/orderDetailsWidget.dart';
import 'package:pluis_hv_app/pluisWidgets/orderDetailsWidgetRemote.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCard.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';
import 'package:pluis_hv_app/register/registerCubit.dart';
import 'package:pluis_hv_app/register/registerRepository.dart';
import 'package:pluis_hv_app/shopCart/shopCartCubit.dart';
import 'package:pluis_hv_app/shopCart/shopCartRepository.dart';
import 'package:pluis_hv_app/splashScreen/SplashScreenRepository.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenCubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/deepLinksBloc.dart';
import 'commons/values.dart';
import 'pluisWidgets/pluisProductCardCubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  log("Init Injector");

  //region Core

  //endregion

  //region SplashScreen
  sl.registerFactory(() => SplashScreenCubit(initializeApp: sl()));

  sl.registerFactory(() => SplashScreenRepository());
  //endregion

  //region LoginPage
  //endregion

  //region AddressBookPage
  sl.registerFactory(() => AddressBookCubit(repository: sl()));

  sl.registerFactory(() => AddressBookRepository(api: sl()));
  //endregion

  //region HomePage
  sl.registerFactory(() => HomePageCubit(repository: sl()));

  sl.registerFactory(() => HomePageCarouselCubit(repository: sl()));

  sl.registerFactory(() => HomePageRepository(api: sl()));

  //endregion

  //region Login
  sl.registerFactory(() => LoginCubit(repository: sl()));

  sl.registerFactory(() => LoginRepository(api: sl()));

  //endregion

  //region Register
  sl.registerFactory(() => RegisterCubit(repository: sl()));

  sl.registerFactory(() => RegisterRepository(api: sl()));
  //endregion

  //region GalleryPage
  sl.registerFactory(() => GalleryPageCubit(repository: sl()));

  sl.registerFactory(() => GalleryRepository(api: sl()));
  //endregion

  //region DetailsPage
  sl.registerFactory(() => DetailsCubit(repository: sl()));

  sl.registerFactory(() => DetailsRepository(api: sl()));
  //endregion

  //region ShopCart
  sl.registerFactory(() => ShopCartCubit(repository: sl()));

  sl.registerFactory(() => ShopCartRepository(api: sl()));
  //endregion

  //region MenuPage
  sl.registerFactory(() => MenuCubit(repository: sl()));

  sl.registerFactory(() => MenuCategoriesExpandableCubit(repository: sl()));

  sl.registerFactory(() => MenuPageRepository(api: sl()));
  //endregion

  //region ProductCard

  sl.registerFactory(() => ProductCardRepository(api: sl()));
  //endregion

  //region OrderDetails
  sl.registerFactory(() => OrderDetailsCubit(repo: sl()));
  sl.registerFactory(() => OrderDetailsRepository(api: sl()));
  //endregion

  //region DeepLinks
  sl.registerFactory(() => DeepLinkBloc());
  //endregion

  //region Dio Client Instance
  sl.registerLazySingleton<ApiClient>(() => ApiClient(serviceUri: WEB_SERVICE));
  //endregion

  sl.registerLazySingleton(
    () => FlutterSecureStorage(),
  );

  sl.registerSingletonAsync(
    () async => await SharedPreferences.getInstance(),
  );

  sl.registerLazySingleton<ShoppingCart>(() => ShoppingCart(shoppingList: []));

  sl.registerLazySingleton<TotalBloc>(
      () => TotalBloc(sum: 0, shoppingCartReference: sl()));

  sl.registerLazySingleton<ColorBloc>(() => ColorBloc(colorsString: "#000000"));
}
