import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PLuisTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBar(controller: PLuisTabBarController(), tabs: [],);
  }
}

class PLuisTabBarController extends TabController {
  // TabController controller = TabController(length: 3, vsync: Ticker);
}
