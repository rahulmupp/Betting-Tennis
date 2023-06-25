import 'package:flutter/material.dart';
import 'package:betting_tennis/globals.dart' as globals;
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailsPageState();
  }
}

class _DetailsPageState extends State<DetailsPage> {
  double? _deviceHeight, _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: _deviceWidth! * 0.90,
          height: _deviceHeight!,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _styledText("Details"),
                    _graph(
                        "Surface Win Percentage", "surface_win%", false, true),
                  ],
                ),
                SizedBox(height: _deviceHeight! * 0.03),
                _graph("Recent Play", "recent_play", false, false),
                SizedBox(height: _deviceHeight! * 0.03),
                _graph("Overall Win Percentage", "win%", false, false),
                SizedBox(height: _deviceHeight! * 0.03),
                _graph("Head to Head Record", "h2h", true, false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _styledText(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.01),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _graph(
      String graphTitle, String jsonIdentifier, bool ish2h, bool isSurface) {
    return Container(
      width: _deviceWidth! * 0.90,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 244, 189),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    graphTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  isSurface
                      ? Text(
                          globals.pressedSurface,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                          ),
                        )
                      : Container(),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: _deviceHeight! * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: VerticalBarchart(
                  maxX: ish2h ? 13 : 100,
                  data: _barData(jsonIdentifier, ish2h),
                  background: const Color.fromARGB(255, 255, 244, 189),
                  showBackdrop: true,
                  barSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _playerGraphVal(String jsonIdentifier, bool ish2h, String num) {
    return ish2h
        ? (globals.decoded["$num" "_$jsonIdentifier"]).toInt()
        : (globals.decoded["$num" "_$jsonIdentifier"] * 100).round();
  }

  List<VBarChartModel> _barData(String jsonIdentifier, bool ish2h) {
    return [
      VBarChartModel(
        index: 0,
        label: globals.pressedPlayer1,
        colors: [Colors.orange, Colors.deepOrange],
        jumlah: _playerGraphVal(jsonIdentifier, ish2h, "p1").toDouble(),
        tooltip: ish2h
            ? "${_playerGraphVal(jsonIdentifier, ish2h, "p1")}"
            : "${_playerGraphVal(jsonIdentifier, ish2h, "p1")}%",
      ),
      VBarChartModel(
        index: 1,
        label: globals.pressedPlayer2,
        colors: [Colors.teal, Colors.indigo],
        jumlah: _playerGraphVal(jsonIdentifier, ish2h, "p2").toDouble(),
        tooltip: ish2h
            ? "${_playerGraphVal(jsonIdentifier, ish2h, "p2")}"
            : "${_playerGraphVal(jsonIdentifier, ish2h, "p2")}%",
      ),
    ];
  }
}
