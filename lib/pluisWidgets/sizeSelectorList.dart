import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageRemoteDataSource.dart';

class SizeSelectorList extends StatefulWidget {
  final Function(String selectedSizeId) onSelecedSizeChange;
  final List<SizeVariationByColor> aviableTallsList;

  const SizeSelectorList(
      {Key key, this.onSelecedSizeChange, this.aviableTallsList})
      : super(key: key);

  @override
  _SizeSelectorList createState() {
    return _SizeSelectorList(
        onSelecedSizeChange: onSelecedSizeChange,
        aviableTallsList: aviableTallsList);
  }
}

class _SizeSelectorList extends State<SizeSelectorList> {
  final Function(String selectedSizeId) onSelecedSizeChange;
  final List<SizeVariationByColor> aviableTallsList;

  _SizeSelectorList({this.onSelecedSizeChange, this.aviableTallsList});

  int selecctedTallIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.aviableTallsList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildSizeInfoWidget(index);
      },
      scrollDirection: Axis.horizontal,
    );
  }

  Widget buildSizeInfoWidget(int index) => Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
        child: GestureDetector(
            onTap: () {
              setState(() {
                if (int.parse(this.aviableTallsList[index].qty) > 0) {
                  this.selecctedTallIndex = index;
                  //Set the tapped tall
                  this
                      .onSelecedSizeChange
                      .call(this.aviableTallsList[index].tall);
                }
              });
            },
            child: Text(
              this.aviableTallsList[index].tall,
              style: TextStyle(
                  fontSize: 18,
                  color: (int.parse(this.aviableTallsList[index].qty) > 0)
                      ? Colors.black
                      : Colors.black12,
                  decoration: (this.selecctedTallIndex == index)
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: Colors.black),
            )),
      );
}
