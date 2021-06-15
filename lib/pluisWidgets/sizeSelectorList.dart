import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis_hv_app/detailsPage/detailsPageRemoteDataSource.dart';
import 'package:pluis_hv_app/observables/aviableSizesObservable.dart';

class SizeSelectorList extends StatefulWidget {
  final Function(String selectedSizeId) onSelecedSizeChange;
  final List<SizeVariationByColor> aviableTallsList;
  final AviableSizesBloc aviableSizesByColorBloc;

  const SizeSelectorList(
      {Key key,
      this.onSelecedSizeChange,
      this.aviableTallsList,
      this.aviableSizesByColorBloc})
      : super(key: key);

  @override
  _SizeSelectorList createState() {
    return _SizeSelectorList(
        onSelecedSizeChange: onSelecedSizeChange,
        aviableTallsList: aviableTallsList,aviableSizesByColorBloc: this.aviableSizesByColorBloc);
  }
}

class _SizeSelectorList extends State<SizeSelectorList> {
  final Function(String selectedSizeId) onSelecedSizeChange;
  final List<SizeVariationByColor> aviableTallsList;
  final AviableSizesBloc aviableSizesByColorBloc;

  _SizeSelectorList(
      {this.onSelecedSizeChange,
      this.aviableTallsList,
      this.aviableSizesByColorBloc});

  int selecctedTallIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: this.aviableSizesByColorBloc.sizesObservable,
        builder: (context, AsyncSnapshot<List<SizeVariationByColor>> snapshot) {
          return (snapshot.data != null) ?ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return buildSizeInfoWidget(index,snapshot.data);
            },
            scrollDirection: Axis.horizontal,
          ):SizedBox.shrink();
        });
  }

  Widget buildSizeInfoWidget(int index,List<SizeVariationByColor> data) => Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
        child: GestureDetector(
            onTap: () {
              setState(() {
                if (int.parse(data[index].qty) > 0) {
                  this.selecctedTallIndex = index;
                  //Set the tapped tall
                  this
                      .onSelecedSizeChange
                      .call(data[index].tall);
                }
              });
            },
            child: Wrap(children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: (this.selecctedTallIndex == index)
                    ? BoxDecoration(
                        border: Border.all(color: Colors.black),
                      )
                    : null,
                child: Text(
                  data[index].tall,
                  style: TextStyle(
                      fontSize: 18,
                      color: (int.parse(data[index].qty) > 0)
                          ? Colors.black
                          : Colors.black12,
                      decorationColor: Colors.black),
                ),
              ),
            ])),
      );
}
