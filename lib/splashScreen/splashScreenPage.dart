import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisLogo.dart';
import 'package:pluis_hv_app/settings/settings.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenCubit.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenStates.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {


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
        Future.delayed(Duration(seconds: 1)).whenComplete(
          () {
            Navigator.of(context).pushReplacementNamed(HOME_PAGE_ROUTE);
          },
        );
      } else if (state is SplashScreenError) {}
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
                        text: 'Tienda PLuis',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: (MediaQuery.of(context).size.height) * 4 / 5,
                width: (MediaQuery.of(context).size.width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(
                      flex: 5,
                    ),
                    LogoImage(),
                    Spacer(
                      flex: 3,
                    )
                  ],
                ),
              ),
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
                        text: 'Tienda PLuis',
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
    Future.delayed(Duration(seconds: 2)).then(
      (value) => requestPermissions().then(
        (value2) => context.bloc<SplashScreenCubit>().start(),
      ),
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
