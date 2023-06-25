import 'package:betting_tennis/pages/details_page.dart';
import 'package:betting_tennis/pages/predictions_page.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:betting_tennis/globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [PredictionsPage(), DetailsPage()];
  double? _deviceHeight, _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _bottomNavigationBar(),
      body: SafeArea(child: _pages[_currentPage]),
    );
  }

  Widget _bottomNavigationBar() {
    return FlashyTabBar(
      selectedIndex: _currentPage,
      onItemSelected: (_index) {
        setState(() {
          _currentPage = _index;
        });
      },
      items: [
        FlashyTabBarItem(
          activeColor: const Color.fromARGB(255, 226, 125, 134),
          title: const Text("Predictions", style: TextStyle(fontSize: 15)),
          icon: const Icon(
            Icons.sports_tennis,
            size: 25,
          ),
        ),
        FlashyTabBarItem(
          activeColor: const Color.fromARGB(255, 226, 125, 134),
          title: const Text("Details", style: TextStyle(fontSize: 15)),
          icon: const Icon(
            Icons.query_stats,
            size: 25,
          ),
        ),
      ],
    );
  }
}
