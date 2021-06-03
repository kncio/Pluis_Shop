import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageCubit.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageState.dart';
import 'package:pluis_hv_app/pluisWidgets/colorSelectorCheckbox.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisButton.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';
import 'package:pluis_hv_app/pluisWidgets/sizeSelectorList.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

import 'detailsPageRemoteDataSource.dart';

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
  List<ProductDetailsImages> imagesList = [];
  bool addTapped = false;
  PanelController _panelController;
  String selectedColorId;
  String selectedTall;

  int index = 0;

  CarouselOptions defaultOptions = CarouselOptions(
    viewportFraction: 1.0,
    enlargeCenterPage: false,
    scrollDirection: Axis.horizontal,
  );

  _DetailsPage({Key key, this.product});

  @override
  void initState() {
    super.initState();
    context.read<DetailsCubit>().getColorsBy(this.product.row_id);
    _panelController = PanelController();
    this.imagesList.add(ProductDetailsImages(product.image));
    context.read<DetailsCubit>().getDetailsImages(this.product.row_id);
    log( "caca " + product.row_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
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
      header: buildHeader());

  Widget buildPanel() {
    return BlocConsumer<DetailsCubit, DetailsPageState>(
        builder: (context, state) {
      switch (state.runtimeType) {
        case DetailsPageSuccess:
          return buildPanelProductInfo();
        case DetailsError:
          return Center(
            child: Text((state as DetailsError).message,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          );
        default:
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
          );
      }
    }, listener: (context, state) async {
      if (state is DetailsError) {
        log(state.message);
      }
      if(state is DetailsImagesLoaded){
        setState(() {
          this.imagesList.addAll(state.imagesList) ;
        });

      }
    });
  }

  Column buildPanelProductInfo() {
    //TODO:  Fetch color and size info from the web
    // COlor size on innitial state then when a color is changed get the correct size information and set
    return Column(children: [
      SizedBox(
        height: 90,
      ),
      Center(
        child: ColorCheckBoxList(
          onIndexChange: (String value) {
            this.selectedColorId = value;
            //For Debug Only
            log(this.selectedColorId);
          },
          colorInfoList: [
            ColorByProductsDataModel(
                id: "1",
                product_id: "1",
                color_id: "3",
                color_name: "Negro",
                color_code: "ff"),
            ColorByProductsDataModel(
                id: "1",
                product_id: "1",
                color_id: "1",
                color_name: "Negro",
                color_code: "ff"),
            ColorByProductsDataModel(
                id: "1",
                product_id: "1",
                color_id: "1",
                color_name: "Negro",
                color_code: "ff"),
            ColorByProductsDataModel(
                id: "1",
                product_id: "1",
                color_id: "1",
                color_name: "Negro",
                color_code: "ff")
          ],
        ),
      ),
      Spacer(flex: 1),
      Expanded(
        child: Center(
          child: SizeSelectorList(
            onSelecedSizeChange: (String tall) {
              this.selectedTall = tall;
              log(this.selectedTall);
            },
            aviableTallsList: [
              SizeVariationByColor(
                  id: "1", color_id: "11", tall: "41", qty: "1"),
              SizeVariationByColor(
                  id: "2", color_id: "22", tall: "42", qty: "0"),
              SizeVariationByColor(
                  id: "3", color_id: "33", tall: "43", qty: "3"),
              SizeVariationByColor(
                  id: "1", color_id: "11", tall: "41", qty: "1"),
              SizeVariationByColor(
                  id: "2", color_id: "22", tall: "42", qty: "0"),
              SizeVariationByColor(
                  id: "3", color_id: "33", tall: "43", qty: "3"),
              SizeVariationByColor(
                  id: "1", color_id: "11", tall: "41", qty: "1"),
              SizeVariationByColor(
                  id: "2", color_id: "22", tall: "42", qty: "0"),
              SizeVariationByColor(
                  id: "3", color_id: "33", tall: "43", qty: "3"),
            ],
          ),
        ),
      )
    ]);
  }

  Widget buildDetailsBody() {
    return Column(
      children: [
        GestureDetector(
          child: createImage(this.imagesList[index].imageUrlName),
          onHorizontalDragEnd: (value){
            setState(() {
              index = (index + 1)%this.imagesList.length;//TODO: improve to only change when horizontal
            });
          },
        )
      ],
    );
  }

  Container buildHeader() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
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
            onPressed: () => {
              if (this._panelController.isPanelOpen)
                {this._panelController.close()}
              else
                {this._panelController.open()}
            },
            icon: Icon(Icons.arrow_upward, color: Colors.black, size: 20),
          ),
        ),
      ),
    );
  }

  SizedBox buildBottomNavigationBar() => SizedBox(
        height: 75,
        child: Row(children: [
          PLuisButton(
            press: addProduct,
            label: 'AÑADIR',
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
                child: IconButton(
                  icon: Icon(Icons.ios_share),
                  onPressed: () => {
                    //TODO: DeepLinks
                  },
                  color: Colors.black,
                )),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
              child: IconButton(
                icon: Icon(Icons.bookmark_border_sharp),
                onPressed: () => {},
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(DEFAULT_PADDING, 0, 1, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SHOP_CART);
                },
                color: Colors.black,
                icon: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
        ]),
      );

  AppBar buildAppBar() => AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: Icon(Icons.clear_outlined),
          color: Colors.black,
        ),
      );

  void addProduct() {
    if (this.selectedTall == null) {
      this._panelController.open();
      showSnackbar(context, text: "Debe seleccionar una talla");
    } else {
      var instance = injectorContainer.sl<ShoppingCart>();
      instance.shoppingList.add(ShoppingOrder(
          productData: this.product,
          product_price: this.product.price,
          id: this.product.row_id,
          name: this.product.name,
          color: this.selectedColorId,
          tall: this.selectedTall,
          qty: 1));
      log("Product Added");
      Navigator.of(context).pushNamed(SHOP_CART);
    }
  }

  Widget createImage(String url) {
    return  Hero(
      tag: url,
      child: FadeInImage.memoryNetwork(
          image: url, placeholder: kTransparentImage),
    );
  }
}
