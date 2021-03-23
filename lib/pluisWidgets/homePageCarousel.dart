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

  List<Widget> getItemsRemote() {
    //TODO: Implementar extraer la informacion mediante la Api(patrin repository)
  }

  //TODO: Investigar como centrar las presentationCards
  List<Widget> getStaticItems() {
    var result = List<Widget>();

    result.add(Stack(
      children: [
        Container(
          height: 800,
          child: Image(image: LocalResources.menImages[5], fit: BoxFit.fill),
        ),
        // Container(
        //   margin: EdgeInsets.fromLTRB(0, 400, 0, 0),
        //   child: PresentationCard(),
        // )
      ],
    ));
    result.add(Stack(
      children: [
        Container(
          height: 800,
          child: Image(
            image: LocalResources.menImages[0],
            fit: BoxFit.fill,
          ),
        ),
        // Container(
        //   margin: EdgeInsets.fromLTRB(0, 400, 0, 0),
        //   child: PresentationCard(),
        // )
      ],
    ));
    return result;
  }
}

Widget buildTabBar() => AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () => {})
      ],
      title: Center(
        child: TabBar(
          isScrollable: true,
          tabs: [
            Tab(
              child: Text(
                "Hombres",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(child: Text("Mujeres", style: TextStyle(color: Colors.black))),
            Tab(child: Text("Niños", style: TextStyle(color: Colors.black))),
          ],
        ),
      ),
    );

class PruebaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 800,
          child: Image(
            image: AssetImage('assets/images/man4.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        HomeAppBar()
      ],
    );
  }
}
