import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/values.dart';

class BottomBar extends StatelessWidget {
  final Function onPressMenu;
  final Function onPressSearch;
  final Function onPressBookmark;
  final Function onPressShopBag;
  final Function onPressAccount;

  const BottomBar({
    Key key,
    this.onPressMenu,
    this.onPressSearch,
    this.onPressBookmark,
    this.onPressShopBag,
    this.onPressAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(DEFAULT_PADDING),
                child: IconButton(
                    onPressed: this.onPressSearch,
                    color: Colors.black,
                    icon: Icon(Icons.home_outlined)),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(DEFAULT_PADDING),
                child: IconButton(
                    onPressed: this.onPressBookmark,
                    color: Colors.black,
                    icon: Icon(Icons.bookmark_border_sharp)),
              ),
            ),
            SizedBox(
                // width: 160,
                width: MediaQuery.of(context).size.width/4,
                child: TextButton(
                  onPressed: this.onPressMenu,
                  child: Text(
                    'MENU',
                    style: TextStyle(color: Colors.black),
                  ),
                )),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(DEFAULT_PADDING),
                child: IconButton(
                    onPressed: this.onPressAccount,
                    color: Colors.black,
                    icon: Icon(Icons.account_box_outlined)),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(DEFAULT_PADDING),
                child: IconButton(
                    onPressed: this.onPressShopBag,
                    color: Colors.black,
                    icon: Icon(Icons.shopping_bag_outlined)),
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 5.0,
          spreadRadius: 1.5,
          offset: Offset(2.0, 2.0),
        )
      ]),
    );
  }
}
