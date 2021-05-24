import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageCubit.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageState.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisButton.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailsPage extends StatefulWidget {
  final Product product;

  const DetailsPage({@required this.product});

  @override
  _DetailsPage createState() {
    return _DetailsPage(product: this.product);
  }
}

//TODO: FAlta maquetar el carousel para mostrar las diferentes fotos,
class _DetailsPage extends State<DetailsPage> {
  final Product product;
  bool addTapped = false;
  PanelController _panelController;

  _DetailsPage({Key key, this.product});

  @override
  void initState() {
    super.initState();
    context.read<DetailsCubit>().getColorsBy(this.product.row_id);
    _panelController = PanelController();
    log(product.row_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: buildColumn(),
    );
  }

  SlidingUpPanel buildColumn() => SlidingUpPanel(
      minHeight: (MediaQuery.of(context).size.height / 10),
      maxHeight: (MediaQuery.of(context).size.height / 3),
      controller: _panelController,
      panelSnapping: true,
      parallaxEnabled: true,
      parallaxOffset: 0.4,
      panel: buildPanel(),
      body: buildDetailsBody(),
      collapsed: buildCollapsed());

  Widget buildPanel() {
    return BlocConsumer<DetailsCubit, DetailsPageState>(
        builder: (context, state) {
          switch(state.runtimeType){
            case DetailsPageSuccess:
              return Center(
                child: Text("TODO"),
              );
            default:
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
              );
          }

        },
        listener: (context, state) async {

        });
  }

  Widget buildDetailsBody() {
    return Column(
      children: [
        Hero(
          tag: '${this.product.name}',
          child: FadeInImage.memoryNetwork(
              image: this.product.image, placeholder: kTransparentImage),
        ),
      ],
    );
  }

  Container buildCollapsed() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
      child: SizedBox(
        height: 50,
        child: ListTile(
          title: Text(
            this.product.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(this.product.price),
          trailing: IconButton(
            onPressed: () => {this._panelController.open()},
            icon: Icon(Icons.arrow_downward, color: Colors.black, size: 20),
          ),
        ),
      ),
    );
  }

  SizedBox buildBottomNavigationBar() => SizedBox(
        height: 75,
        child: Row(children: [
          PLuisButton(
            press: () => {},
            label: 'AÑADIR',
          ),
          SizedBox(
            width: 100,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
              child: IconButton(
                icon: Icon(Icons.ios_share),
                onPressed: () => {},
                color: Colors.black,
              )),
          Container(
            padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
            child: IconButton(
              icon: Icon(Icons.bookmark_border_sharp),
              onPressed: () => {},
              color: Colors.black,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
            child: IconButton(
              onPressed: () => {},
              color: Colors.black,
              icon: Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ]),
      );

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: Icon(Icons.clear_outlined),
          color: Colors.black,
        ),
      );
}
