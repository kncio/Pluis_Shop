import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/commons/localResourcesPool.dart';
import 'package:pluis_hv_app/commons/values.dart';
import 'package:pluis_hv_app/homePage/homeDataModel.dart';
import 'package:pluis_hv_app/pluisWidgets/pluisProductCard.dart';
import 'package:pluis_hv_app/pluisWidgets/presentationCard.dart';
import 'package:transparent_image/transparent_image.dart';

import 'homeAppBar.dart';

class HomePageCarousel extends StatelessWidget {
  final CarouselOptions defaultOptions = CarouselOptions(
    viewportFraction: 1.0,
    enlargeCenterPage: false,
    scrollDirection: Axis.vertical,
  );

  final List<SlidesInfo> imagesUrls;

  HomePageCarousel({Key key, this.imagesUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: 800,
          child:
              CarouselSlider(items: List<Widget>.from(imagesUrls.map((url) => createImage(url.image))), options: defaultOptions)),
    ]);
  }

  
  // List<Widget> getImagesFromUrls() {
  //   var result = List<Widget>();
  //
  //   result.add(Container(
  //     height: 800,
  //     child: FadeInImage.memoryNetwork(image: ),
  //   ));
  //   result.add(Container(
  //     height: 800,
  //     child: Image(
  //       image: LocalResources.menImages[0],
  //       fit: BoxFit.fill,
  //     ),
  //   ));
  //   return result;
  // }

  Widget createImage(String url){
    return Container(
      height: 800,
      child: FadeInImage.memoryNetwork(image: url,placeholder: kTransparentImage,),
    );
  }

}




