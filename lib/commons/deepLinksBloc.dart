import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;
import 'package:pluis_hv_app/splashScreen/SplashScreenRepository.dart';

abstract class Bloc {
  void dispose();
}

class DeepLinkBloc extends Bloc {
  //Event Channel creation
  static const stream = const EventChannel('poc.calzadopluis.com/events');

  //Method channel creation
  static const platform = const MethodChannel('poc.calzadopluis.com/channel');

  StreamController<String> _stateController = StreamController();

  Stream<String> get state => _stateController.stream;

  Sink<String> get stateSink => _stateController.sink;

  //Adding the listener into contructor
  DeepLinkBloc() {
    //Checking application start by deep link
    startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  _onRedirected(String uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream
    log(uri);
    if (_checkLink(uri)) {
      injectorContainer
          .sl<SplashScreenRepository>()
          .initializeApp()
          .then((value) => stateSink.add(uri));
    } else {
      injectorContainer
          .sl<SplashScreenRepository>()
          .initializeApp()
          .then((value) => stateSink.add("https://calzadopluis.com"));
    }
  }

  bool _checkLink(String uri) {
    var rawLink = uri.replaceAll("https://calzadopluis.com/", "");

    if (rawLink.split("/")[0] != "product") {
      return false;
    }
    try {
      var pid = int.parse(rawLink.split("/")[1]);
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  void dispose() {
    _stateController.close();
  }

  Future<String> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}
