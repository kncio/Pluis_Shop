import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pluis_hv_app/commons/keyStorage.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/userInfo/roleManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injectorContainer.dart';

class Settings {
  // url info
  static Map<String, dynamic> get uriInfo {
    final prefs = sl<SharedPreferences>();
    String server = prefs?.getString(SERVER_ENTERED) ?? SERVER_DEBUG_IP;
    String port = prefs?.getString(PORT_ENTERED) ?? SERVER_PORT;
    // String server = '127.0.0.1';
    // String port = SERVER_PORT;
    log("configurando" + server);
    bool httpProtocol = (prefs?.getBool(PROTOCOL_ENTERED) ?? false);
    return {
      SERVER_ENTERED: server,
      PORT_ENTERED: port,
      PROTOCOL_ENTERED: httpProtocol
    };
  }

  static String get uri {
    var info = Settings.uriInfo;
    assert(info != null &&
        info.values.where((element) => element != null).length == 3);

    return (info[PROTOCOL_ENTERED] ? 'https://' : 'http://') +
        info[SERVER_ENTERED] +
        ':' +
        info[PORT_ENTERED];
  }

  static Future<void> setServerConfiguration({
    String server,
    String port,
    bool httpsProtocol,
  }) async {
    assert(server != null && port != null && httpsProtocol != null);
    final prefs = sl<SharedPreferences>();

    log("server entered is " + SERVER_ENTERED.toString());

    prefs?.setString(SERVER_ENTERED, server);
    prefs?.setString(PORT_ENTERED, port);
    prefs?.setBool(PROTOCOL_ENTERED, httpsProtocol);
  }

  static String get webService => WEB_SERVICE;

  static String get previewZoomRepository => PREVIEW_ZOOM_REPOSITORY;

  static String get previewZoomApp => PREVIEW_ZOOM_APP;

  /// in milliseconds
  static int get requestTimeLimit => REQUEST_TIME_LIMIT;

  // user info
  static bool get isLoggedIn {
    final prefs = sl<SharedPreferences>();
    bool isLoggedIn = prefs?.getBool(USER_LOGGED) ?? false;
    return isLoggedIn;
  }

  static bool get remember {
    final prefs = sl<SharedPreferences>();
    bool remember = prefs?.getBool(REMEMBER) ?? false;
    return remember;
  }

  static Future<String> get storedToken async {
    if (!isLoggedIn) return '';
    final secureStorage = sl<FlutterSecureStorage>();
    var token = await secureStorage.read(key: USER_TOKEN_KEY);
    return token;
  }

  static Future<String> get storedApiToken async {
    final secureStorage = sl<FlutterSecureStorage>();
    var appToken = await secureStorage.read(key: API_TOKEN_KEY);
    if (appToken != "") {
      return appToken;
    }
    return "no_token_stored";
  }

  static Future<Map<String, String>> get storedCredentials async {
    if (isLoggedIn) {
      final secureStorage = sl<FlutterSecureStorage>();
      String userEmail = await secureStorage.read(
        key: USER_EMAIL,
      );
      String password = await secureStorage.read(
        key: USER_PASSWORD,
      );
      String token = await secureStorage.read(
        key: USER_TOKEN_KEY,
      );
      if (userEmail != null && password != null && token != null)
        return {
          USER_EMAIL: userEmail,
          USER_PASSWORD: password,
          USER_TOKEN_KEY: token,
        };
    }
    return {};
  }

  static Future<Map<String, String>> get storedUserProfileInformation async {
    // TODO: IMPLEMENT THE USER PUBLIC INFO TO RETRIEVE
    return {};
  }

  // set user info
  static void setIsLoggedIn({bool value = true}) {
    final prefs = sl<SharedPreferences>();
    prefs.setBool(USER_LOGGED, value);
  }

  static void setRememberMe({bool value = true}) {
    final prefs = sl<SharedPreferences>();
    prefs.setBool(REMEMBER, value);
  }

  static Future<void> setCredentials({
    @required userEmail,
    @required String token,
    bool rememberMe,
  }) async {
    Settings.setIsLoggedIn(value: true);
    Settings.setRememberMe(value: rememberMe ?? false);

    final secureStorage = sl<FlutterSecureStorage>();
    await secureStorage.write(
      key: USER_EMAIL,
      value: userEmail,
    );
    await secureStorage.write(
      key: USER_TOKEN_KEY,
      value: token,
    );
  }

  static Future<void> setApiToken({@required apiToken}) async {
    final secureStorage = sl<FlutterSecureStorage>();
    await secureStorage.write(key: API_TOKEN_KEY, value: apiToken);
  }

  static Future<void> setUserProfileInformation() async {
    // TODO: IMPLEMENT STORE USER PUBLIC INFO
    return {};
  }

  static void invalidateCredentials() {
    final prefs = sl<SharedPreferences>();
    prefs.setBool(USER_LOGGED, false);
  }

  static Future<void> setRoles({
    List<String> titles,
  }) async {
    RolePermssionManager.updateRightAndRoles(roleTitles: titles);
    return Settings._setStringList(USER_ROLE_TITLES, titles);
  }

  static Future<void> setRights({
    List<String> rights,
  }) async {
    RolePermssionManager.updateRightAndRoles(userRights: rights);
    return Settings._setStringList(USER_RIGHTS, rights);
  }

  static Future<void> _setStringList(String key, List<String> values) async {
    assert(values != null);
    if (isLoggedIn) {
      final prefs = sl<SharedPreferences>();
      prefs.setStringList(
        key,
        values,
      );
    }
  }

  static Future<List<String>> get storedUserRights async {
    RolePermssionManager.updateRightAndRoles(
        userRights: await Settings._getStringList((USER_RIGHTS)));
    return RolePermssionManager.userRights;
  }

  static Future<List<String>> get storedRoleTitles async {
    RolePermssionManager.updateRightAndRoles(
        roleTitles: await Settings._getStringList(USER_ROLE_TITLES));
    return RolePermssionManager.roleTitles;
  }

  static Future<List<String>> _getStringList(String key) async {
    if (isLoggedIn) {
      final prefs = sl<SharedPreferences>();
      var list = prefs.getStringList(key);
      return list;
    }
    return [];
  }

  // external storage config
  static Future<Directory> get getAppExternalStorageBaseDirectory async {
    Directory baseDir = await getExternalStorageDirectory();
    String appDirectory = '${baseDir.path}';
    return Directory(appDirectory);
  }

  static Future<Map<Permission, PermissionStatus>> requestPermission(
      {Permission permission, List<Permission> permissionsToRequest}) async {
    assert(permission != null && permissionsToRequest == null ||
        permissionsToRequest != null && permission == null);

    if (permission != null) return {permission: await permission.request()};
    return await permissionsToRequest.request();
  }
}
