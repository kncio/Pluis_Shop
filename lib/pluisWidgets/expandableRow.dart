import 'package:dartz/dartz.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/argsClasses.dart';
import 'package:pluis_hv_app/commons/pagesRoutesStrings.dart';

class ExpandableRow extends StatelessWidget {
  final String headerName;
  final List<Map<String, dynamic>> itemsNames;

  //TODO: Introduce onClick action
  const ExpandableRow({Key key, this.headerName, this.itemsNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildItem(String label, String id, bool discountOnly) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          onPressed: () => {
            (discountOnly)
                ? Navigator.pushNamed(context, GALERY_SCREEN_PAGE_ROUTE,
                    arguments: GalleryArgs(
                        categoryId: id, name: "REBAJAS", discountOnly: true))
                : Navigator.pushNamed(context, GALERY_SCREEN_PAGE_ROUTE,
                    arguments: GalleryArgs(categoryId: id, name: label,discountOnly: false))
          },
          child: Text(label),
        ),
      );
    }

    buildList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (var i in this.itemsNames)
            buildItem("${i['categoryName']}", i["id"], i["discountOnly"]),
        ],
      );
    }

    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Column(
          children: <Widget>[
            ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToExpand: true,
                tapBodyToCollapse: true,
                hasIcon: false,
              ),
              header: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          this.headerName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              expanded: buildList(),
            ),
          ],
        ),
      ),
    );
  }
}
