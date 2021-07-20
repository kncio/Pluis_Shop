import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenCubit.dart';
import 'package:pluis_hv_app/splashScreen/splashScreenPage.dart';
import 'package:provider/provider.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectionContainer;
import 'deepLinksBloc.dart';

import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class PocWidget extends StatelessWidget {


  const PocWidget({Key key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);//
    var _bloc = injectorContainer.sl<DeepLinkBloc>();
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          log("no data");
          return BlocProvider<SplashScreenCubit>(
            create: (_) => injectionContainer.sl<SplashScreenCubit>(),
            child: SplashScreenPage(),
          );
        } else {
          log("data");
          return Scaffold(
            body: Container(
                child: Center(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Redirected: ${snapshot.data}',
                            style: Theme.of(context).textTheme.title)))),
          );
        }
      },
    );
  }
}
