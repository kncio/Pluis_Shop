import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/pluisWidgets/expandableRow.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPage createState() {
    return _MenuPage();
  }
}

class _MenuPage extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildTabBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() => TabBarView(
        children: [
          buildListViewMen(),
          buildListViewWomen(),
          buildListViewChildren()
        ],
      );

  ListView buildListViewWomen() {
    return ListView(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => {},
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 30, 0, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "NUEVO",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ExpandableRow(
              headerName: "COLECCIONES",
              itemsNames: [
                "ZAPATOS",
                "BOLSAS",
                "PANTALONES",
                "ACCESORIOS",
                "ABRIGOS"
              ],
            ),
            ExpandableRow(
              headerName: "ACCESORIOS",
              itemsNames: ["RELOJES", "PULSERAS", "CADENAS", "GORRAS", "GAFAS"],
            )
          ],
        ),
      )
    ]);
  }

  ListView buildListViewMen() {
    return ListView(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => {},
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 30, 0, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "NUEVO",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ExpandableRow(
              headerName: "COLECCIONES",
              itemsNames: [
                "ZAPATOS",
                "BOLSAS",
                "PANTALONES",
                "ACCESORIOS",
                "ABRIGOS"
              ],
            ),
            ExpandableRow(
              headerName: "ACCESORIOS",
              itemsNames: ["RELOJES", "PULSERAS", "CADENAS", "GORRAS", "GAFAS"],
            )
          ],
        ),
      )
    ]);
  }

  Widget buildTabBar() => AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop())
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
              Tab(
                  child:
                      Text("Mujeres", style: TextStyle(color: Colors.black))),
              Tab(child: Text("Niños", style: TextStyle(color: Colors.black))),
            ],
          ),
        ),
      );

  buildListViewChildren() {
    return ListView(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => {},
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 30, 0, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "NUEVO",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ExpandableRow(
              headerName: "COLECCIONES",
              itemsNames: [
                "ZAPATOS",
                "BOLSAS",
                "PANTALONES",
                "ACCESORIOS",
                "ABRIGOS"
              ],
            ),
            ExpandableRow(
              headerName: "ACCESORIOS",
              itemsNames: ["RELOJES", "PULSERAS", "CADENAS", "GORRAS", "GAFAS"],
            )
          ],
        ),
      )
    ]);
  }

//TODO: Implement get categories for collection expandable item and dynamic content

}
