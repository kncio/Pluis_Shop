import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'deepLinksBloc.dart';

import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

class PocWidget extends StatelessWidget {
  final Widget noDeepUsedApp;

  const PocWidget({Key key, this.noDeepUsedApp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);//
    var _bloc = injectorContainer.sl<DeepLinkBloc>();
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return noDeepUsedApp;
        } else {
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
