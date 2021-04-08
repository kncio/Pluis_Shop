import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/galleryPage/galleryPageCubit.dart';
import 'package:pluis_hv_app/galleryPage/galleryRepository.dart';
import 'package:pluis_hv_app/homePage/homePageCubit.dart';
import 'package:pluis_hv_app/loginPage/loginCubit.dart';
import 'package:pluis_hv_app/loginPage/loginRepository.dart';
import 'package:pluis_hv_app/menuPage/menuCubit.dart';
import 'package:pluis_hv_app/register/registerCubit.dart';
import 'package:pluis_hv_app/register/registerRepository.dart';
import 'package:pluis_hv_app/shopCart/shopCartCubit.dart';
import 'package:pluis_hv_app/splashScreen/SplashScreenRepository.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenCubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/jsonRpc.dart';
import 'commons/values.dart';

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

  //region HomePage
  sl.registerFactory(() => HomePageCubit());

  //endregion

  //region Login
  sl.registerFactory(() => LoginCubit(repository: sl()));

  sl.registerFactory(() => LoginRepository(api: sl()));

  //endregion

  //region Register
  sl.registerFactory(() => RegisterCubit(repository: sl()));

  sl.registerFactory(() => RegisterRepository(api:sl()));
  //endregion

  //region GalleryPage
  sl.registerFactory(() => GalleryPageCubit(repository: sl()));

  sl.registerFactory(() => GalleryRepository(api:  sl()));
  //endregion

  //region ShopCart
  sl.registerFactory(() => ShopCartCubit());
  //endregion

  //region MenuPage
  sl.registerFactory(() => MenuCubit());
  //endregion

  //region Json Http Client
  sl.registerLazySingleton<JsonRPCClient>(
    () => JsonRPCClient.jsonRPCHTTPClient(
      rpcVersion: DEFAULT_RPC_VERSION,
    ),
  );
  //endregion

  //region Dio Client Instance
  sl.registerLazySingleton<ApiClient>(() => ApiClient(
    serviceUri: WEB_SERVICE
  ));
  //endregion

  sl.registerLazySingleton(
        () => FlutterSecureStorage(),
  );

  sl.registerSingletonAsync(
        () async => await SharedPreferences.getInstance(),
  );
}
