import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageRemoteDataSource.dart';

class ColorCheckBoxList extends StatefulWidget {
  final List<ColorByProductsDataModel> colorInfoList;
  final int selectedColor;

  final Function(String additive, String selectedIndex) onIndexChange;

  ColorCheckBoxList(
      {Key key, this.selectedColor, this.onIndexChange, this.colorInfoList})
      : super(key: key);

  @override
  _ColorCheckBox createState() {
    return _ColorCheckBox(
        colorInfoList: colorInfoList, onIndexChange: onIndexChange);
  }
}

class _ColorCheckBox extends State<ColorCheckBoxList> {
  final List<ColorByProductsDataModel> colorInfoList;

  //Function Called when the user change the colorIndex
  final Function onIndexChange;

  int selectedColor = 0;

  _ColorCheckBox({this.onIndexChange, this.colorInfoList, selectedColorIndex}) {
    this.selectedColor = selectedColorIndex;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: this.colorInfoList.length,
            itemBuilder: (BuildContext context, int index) {
              return buildCheckColorIndicator(this.colorInfoList[index], index);
            }));
  }

  Padding buildCheckColorIndicator(
      ColorByProductsDataModel currentColorInfo, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            this.selectedColor = index;
            //Set the color id of the selected color
            onIndexChange.call(currentColorInfo.color_id,
                this.colorInfoList[index].color_code);
          });
        },
        child: Wrap(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(alignment: AlignmentDirectional.center,children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 4,color: (this.selectedColor == index)?Colors.black:Colors.transparent),
                    shape: BoxShape.circle
                  ),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      shape: BoxShape.circle,
                      color: Color(hexColor(currentColorInfo.color_code))),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                  ),
                ),
              ]),
              Text(currentColorInfo.color_name.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
        ]),
      ),
    );
  }

  int hexColor(String colorCodeString) {
    String xFormat = "0xff" + colorCodeString;
    xFormat = xFormat.replaceAll('#', '');
    int xIntFormat = int.parse(xFormat);
    return xIntFormat;
  }
}
