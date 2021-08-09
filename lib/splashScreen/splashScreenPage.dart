import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pluis_hv_app/commons/deepLinksBloc.dart';
import 'package:pluis_hv_app/commons/pagesRoutes.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/observables/deepLinkFlag.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisLogo.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenCubit.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenStates.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;
import 'package:provider/provider.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  double logoWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocConsumer<SplashScreenCubit, SplashScreenState>(
        listener: (context, state) async {
      if (state is SplashScreenAppInitializedSuccess) {
        Future.delayed(Duration(seconds: 3, milliseconds: 500)).whenComplete(
          () {
            Settings.invalidateCredentials();
            if (!Settings.deepLinkEntry) {
              Navigator.of(context).pushReplacementNamed(HOME_PAGE_ROUTE);
            } else {
              //pop the splash screen
              Future.delayed(Duration(seconds: 5)).then((value) => {
                    injectorContainer.sl<DeepLinkFlag>().flagOn(),
                    log("sink"),
                  });
            }
          },
        );
      } else if (state is SplashScreenError) {
      } else if (state is SplashScreenAnimationStartState) {
        setState(() {
          this.logoWidth = MediaQuery.of(context).size.width * 3 / 4;
        });
      }
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case SplashScreenError:
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              ),
              Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(
                    "No hay conexión a internet o el servidor se esta tardando en responder"
                        .toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              Center(
                  child: IconButton(
                icon: Icon(Icons.refresh_sharp, color: Colors.black),
                onPressed: () async {
                  await initializeApp();
                },
                iconSize: 60,
              )),
              Spacer(
                flex: 1,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Version: $ApplicationVersion\nCopyright \u00a9 2021 - ',
                      ),
                      TextSpan(
                        text: '$pluisString',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        default:
          return Column(
            children: [
              Spacer(
                flex: 2,
              ),
              Center(
                child: AnimatedContainer(
                  width: this.logoWidth,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(seconds: 3),
                  child: LogoImage(),
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Version: $ApplicationVersion\nCopyright \u00a9 2021 - ',
                      ),
                      TextSpan(
                        text: '$pluisString',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    requestPermissions().then(
      (value2) => context.read<SplashScreenCubit>().start(),
    );
  }

  Future<Map<Permission, PermissionStatus>> requestPermissions() async {
    Map<Permission, PermissionStatus> status = await Settings.requestPermission(
        permissionsToRequest: [Permission.storage]);
    if (status.entries.any((element) => element.value.isDenied))
      return await requestPermissions();
    return status;
  }
}
