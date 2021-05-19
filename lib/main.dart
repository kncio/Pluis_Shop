import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluis_hv_app/PluisApp.dart';
import 'package:pluis_hv_app/commons/localResourcesPool.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'commons/apiClient.dart';
import 'injectorContainer.dart' as injectorContainer;

void main() {

  //region Prevent Landscape Mode
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //endregion

  initialize().whenComplete(() => {
    //! Run the APP
    runApp(PluisApp())});
}

Future<void> initialize() async {

  // LocalResources.menImages.add(AssetImage('assets/images/Bota Brantano azul1.jpg'));
  // LocalResources.menImages.add(AssetImage('assets/images/Bota Plana.jpg'));
  // LocalResources.menImages.add(AssetImage('assets/images/Bota Ziper Elástico1.jpg'));
  // LocalResources.menImages.add(AssetImage('assets/images/Colegial tegijo charol1.jpg'));
  // LocalResources.menImages.add(AssetImage('assets/images/Bota Dayi Hebilla NG1.jpg'));
  // LocalResources.menImages.add(AssetImage('assets/images/Bota Rojo 1.jpg'));

  log('Initializing APk resources');
  injectorContainer.init();

}
