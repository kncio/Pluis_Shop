import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableRow extends StatelessWidget {
  final String headerName;
  final List<String> itemsNames;

  const ExpandableRow({Key key, this.headerName, this.itemsNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          onPressed: () => {},
          child: Text(label),
        ),
      );
    }

    buildList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (var i in this.itemsNames) buildItem("${i}"),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
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
