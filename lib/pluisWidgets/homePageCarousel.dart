import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/commons/localResourcesPool.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCard.dart';
import 'package:pluis_hv_app/pluisWidgets/presentationCard.dart';

import 'homeAppBar.dart';

class HomePageCarousel extends StatelessWidget {
  final CarouselOptions defaultOptions = CarouselOptions(
    viewportFraction: 1.0,
    enlargeCenterPage: false,
    scrollDirection: Axis.vertical,
  );

  final List<String> imagesUrls;

  HomePageCarousel({Key key, this.imagesUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: 800,
          child:
              CarouselSlider(items: getStaticItems(), options: defaultOptions)),
      // HomeAppBar()


    ]);
  }

  List<Widget> getItemsRemote(List<String> imagesUrls) {
    //TODO: Map each list element and create widget for display
    //TODO: THink a good way to do it
  }


  List<Widget> getStaticItems() {
    var result = List<Widget>();

    result.add(Container(
      height: 800,
      child: Image(image: LocalResources.menImages[5], fit: BoxFit.fill),
    ));
    result.add(Container(
      height: 800,
      child: Image(
        image: LocalResources.menImages[0],
        fit: BoxFit.fill,
      ),
    ));
    return result;
  }
}




