import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluis_hv_app/PluisApp.dart';
import 'package:pluis_hv_app/settings/settings.dart';

import 'injectorContainer.dart' as injectorContainer;

void main() {
  //region Prevent Landscape Mode
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //endregion

  initialize().whenComplete(() => {
        //! Run the APP
        runApp(PluisApp())
      });
}

Future<void> initialize() async {
  log('Initializing APk resources');
  injectorContainer.init();
}
