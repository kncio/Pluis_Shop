import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';
import 'package:pluis_hv_app/commons/productsModel.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageCubit.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageState.dart';
import 'package:pluis_hv_app/observables/aviableSizesObservable.dart';
import 'package:pluis_hv_app/pluisWidgets/colorSelectorCheckbox.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisButton.dart';
import 'package:pluis_hv_app/pluisWidgets/shoppingCartDataModel.dart';
import 'package:pluis_hv_app/pluisWidgets/sizeSelectorList.dart';
import 'package:pluis_hv_app/pluisWidgets/snackBar.dart';
import 'package:share/share.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;

import 'detailsPageRemoteDataSource.dart';

class DetailsPage extends StatefulWidget {
  final Product product;
  final String selectedCurrencyNomenclature;

  const DetailsPage({
    @required this.product,
    @required this.selectedCurrencyNomenclature,
  });

  @override
  _DetailsPage createState() {
    return _DetailsPage(
      product: this.product,
      selectedCurrencyNomenclature: this.selectedCurrencyNomenclature,
    );
  }
}

class _DetailsPage extends State<DetailsPage> {
  final String selectedCurrencyNomenclature;
  final Product product;

  List<ProductDetailsImages> imagesList = [];
  bool addTapped = false;
  PanelController _panelController;

  String selectedCoclorHexString;
  String selectedColorId;
  int selectedColorIndex;
  String selectedTall;

  AviableSizesBloc _aviableSizesByColorBloc;
  List<SizeVariationByColor> sizesByColor = [];
  List<ColorByProductsDataModel> colorList = [];

  int index = 0;

  CarouselOptions defaultOptions = CarouselOptions(
    viewportFraction: 1.0,
    enlargeCenterPage: false,
    scrollDirection: Axis.horizontal,
  );

  //normal Price Variation(for current currency)
  String normalPrice = "";

  //discount Price Variation(for current currency)
  String discountPrice = "";

  _DetailsPage({
    Key key,
    this.product,
    this.selectedCurrencyNomenclature,
  });

  @override
  void initState() {
    super.initState();
    // if (this.fromDeepLink) {
    //   context
    //       .read<DetailsCubit>()
    //       .getProductDetail(this.product.row_id)
    //       .then((value) => {this.product = value, _retrieveProductnfo()});
    // } else {
    _retrieveProductnfo();
    // }
  }

  void _retrieveProductnfo() {
    normalPrice = this.product.price;
    discountPrice = this.product.discount_price;

    this._aviableSizesByColorBloc = AviableSizesBloc(aviableSizes: []);
    context.read<DetailsCubit>().getColorsBy(this.product.row_id);
    _panelController = PanelController();
    this.imagesList.add(ProductDetailsImages(product.image));
    context
        .read<DetailsCubit>()
        .getDetailsImages(this.product.row_id)
        .then((list) => this.setState(() {
              this.imagesList.addAll(list);
            }));

    context
        .read<DetailsCubit>()
        .getPriceVariations(this.product.price)
        .then((value) => {
              this.setState(() {
                this.normalPrice = value
                    .where((element) =>
                        element.coin == this.selectedCurrencyNomenclature)
                    .first
                    .price;
              })
            });
    context
        .read<DetailsCubit>()
        .getPriceVariations(this.product.discount_price)
        .then((value) => {
              this.setState(() {
                this.discountPrice = value
                    .where((element) =>
                        element.coin == this.selectedCurrencyNomenclature)
                    .first
                    .price;
              })
            });
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
        case DetailsPageSuccessColor:
          return buildPanelProductInfo(this.selectedColorIndex);
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
      if (state is DetailsPageSuccessColor) {
        this.colorList = (state as DetailsPageSuccessColor).colorsBy;
        context
            .read<DetailsCubit>()
            .getSizeByColor(this.colorList[0].color_id)
            .then((list) => this._aviableSizesByColorBloc.updateBills(list));

        // context.read<DetailsCubit>().setSuccess();
      }
    });
  }

  Column buildPanelProductInfo(int currentIndex) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 90,
      ),
      Center(
        child: ColorCheckBoxList(
          selectedColor: currentIndex,
          onIndexChange: (String value, String hexCode) {
            this.selectedColorId = value;
            this.selectedCoclorHexString = hexCode;
            context
                .read<DetailsCubit>()
                .getSizeByColor(this.selectedColorId)
                .then(
                    (list) => this._aviableSizesByColorBloc.updateBills(list));
            //For Debug Only
            log(this.selectedColorId);
          },
          colorInfoList: this.colorList,
        ),
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(30, 16, 0, 16),
          child: Text(
            "Tallas:",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      Expanded(
        child: Center(
          child: SizeSelectorList(
            onSelecedSizeChange: (String tall) {
              this.selectedTall = tall;
            },
            aviableSizesByColorBloc: this._aviableSizesByColorBloc,
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
          onHorizontalDragEnd: (value) {
            setState(() {
              index = (index + 1) %
                  this
                      .imagesList
                      .length; //TODO: improve to only change when horizontal
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
          subtitle: buildPriceInfoContainer(),
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

  RichText buildPriceInfoContainer() {
    return RichText(
        text: TextSpan(style: TextStyle(color: Colors.grey), children: [
      TextSpan(
          text: this.normalPrice,
          style: TextStyle(
              decorationColor: Colors.red,
              decorationThickness: 2.85,
              decoration: (this.product.is_discount == "1")
                  ? TextDecoration.lineThrough
                  : TextDecoration.none)),
      (this.product.is_discount == "1")
          ? TextSpan(text: "  ${this.discountPrice}")
          : TextSpan(text: ""),
      TextSpan(text: "  ${this.selectedCurrencyNomenclature}")
    ]));
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
                    Share.share(
                        "https://calzadopluis.com/product?id=${this.product.row_id}&image=${this.product.image.replaceAll("https://www.calzadopluis.com/writable/uploads/images/", "")}&coin=${this.selectedCurrencyNomenclature}")
                  },
                  color: Colors.black,
                )),
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
          qty: 1,
          hexColorInfo: selectedCoclorHexString));
      log("Product Added");
      Navigator.of(context).pushNamed(SHOP_CART);
    }
  }

  Widget createImage(String url) {
    return Hero(
      tag: url,
      child:
          FadeInImage.memoryNetwork(image: url, placeholder: kTransparentImage),
    );
  }
}
