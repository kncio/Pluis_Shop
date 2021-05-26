import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageRemoteDataSource.dart';

class ColorCheckBoxList extends StatefulWidget {
  final List<ColorByProductsDataModel> colorInfoList;

  const ColorCheckBoxList({Key key, this.colorInfoList}) : super(key: key);

  @override
  _ColorCheckBox createState() {
    return _ColorCheckBox(colorInfoList: colorInfoList);
  }
}

class _ColorCheckBox extends State<ColorCheckBoxList> {
  final List<ColorByProductsDataModel> colorInfoList;

  bool checked = false;
  int selectedColor = 0;

  _ColorCheckBox({this.colorInfoList});

  @override
  void initState() {
    super.initState();
    this.checked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
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
          });
        },
        child: Wrap(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 3,
                        color: (this.selectedColor == index)
                            ? Colors.black
                            : Colors.transparent),
                    shape: BoxShape.circle,
                    color: Color(hexColor(currentColorInfo.color_code))),
                child: SizedBox(
                  width: 50,
                  height: 50,
                ),
              ),
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
    return 0xffADD8E6;
  }
}
