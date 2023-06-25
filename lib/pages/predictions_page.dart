import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:betting_tennis/globals.dart' as globals;

import '../function.dart';

class PredictionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PredictionsPageState();
  }
}

class _PredictionsPageState extends State<PredictionsPage> {
  double? _deviceHeight, _deviceWidth;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    globals.getJson();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          width: _deviceWidth! * 0.90,
          height: _deviceHeight!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _styledText("Predictions"),
                  _playersBox(),
                ],
              ),
              isLoading ? _loadingIndicator() : _generateButton(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _styledText("Winner"),
                  _resultsBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return Center(
      child: SizedBox(
        height: _deviceHeight! * 0.08,
        width: _deviceHeight! * 0.08,
        child: const CircularProgressIndicator(
            color: Color.fromARGB(255, 226, 125, 134)),
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

  Widget _playersBox() {
    return Container(
      width: _deviceWidth! * 0.90,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 244, 189),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            _player1Dropdown(),
            SizedBox(height: _deviceHeight! * 0.04),
            _player2Dropdown(),
            SizedBox(height: _deviceHeight! * 0.04),
            _surfacesDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _player1Dropdown() {
    return DropdownSearch<String>(
      popupProps: const PopupProps.menu(
        searchDelay: Duration(seconds: 0),
        showSearchBox: true,
        showSelectedItems: true,
      ),
      items: globals.players,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Player 1",
          hintText: "Choose Player",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
      onChanged: (player) {
        setState(() {
          globals.player1 = player!;
          globals.urlPlayer1 = globals.player1.replaceAll(" ", "+");
          globals.url =
              "http://mltennis.pythonanywhere.com/api?player1=${globals.urlPlayer1}&player2=${globals.urlPlayer2}&surface=${globals.surface}";
        });
      },
      selectedItem: globals.player1,
    );
  }

  Widget _player2Dropdown() {
    return DropdownSearch<String>(
      popupProps: const PopupProps.menu(
        searchDelay: Duration(seconds: 0),
        showSearchBox: true,
        showSelectedItems: true,
      ),
      items: globals.players,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Player 2",
          hintText: "Choose Player",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
      onChanged: (player) {
        setState(() {
          globals.player2 = player!;
          globals.urlPlayer2 = globals.player2.replaceAll(" ", "+");
          globals.url =
              "http://mltennis.pythonanywhere.com/api?player1=${globals.urlPlayer1}&player2=${globals.urlPlayer2}&surface=${globals.surface}";
        });
      },
      selectedItem: globals.player2,
    );
  }

  Widget _surfacesDropdown() {
    return DropdownSearch<String>(
      popupProps: const PopupProps.menu(
        searchDelay: Duration(seconds: 0),
        showSearchBox: true,
        showSelectedItems: true,
      ),
      items: globals.surfaces,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Surface",
          hintText: "Choose Surface",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
      onChanged: (_surface) {
        setState(() {
          globals.surface = _surface!;
          globals.url =
              "http://mltennis.pythonanywhere.com/api?player1=${globals.urlPlayer1}&player2=${globals.urlPlayer2}&surface=${globals.surface}";
        });
      },
      selectedItem: globals.surface,
    );
  }

  Widget _generateButton() {
    return MaterialButton(
      height: _deviceHeight! * 0.08,
      minWidth: _deviceWidth! * 0.90,
      color: const Color.fromARGB(255, 226, 125, 134),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: _buttonPressed,
      child: const Text(
        "Generate",
        softWrap: false,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  _buttonPressed() async {
    setState(() {
      isLoading = true;
    });

    globals.url =
        "http://mltennis.pythonanywhere.com/api?player1=${globals.urlPlayer1}&player2=${globals.urlPlayer2}&surface=${globals.surface}";
    globals.data = await fetchData(globals.url);

    try {
      globals.decoded = jsonDecode(globals.data);
    } on Exception catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text("Input Error"),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('An error has occurred.'),
                  Text('A player has not played on this surface.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      isLoading = false;
      globals.percentage = (globals.decoded['probability'] * 100).round();
      globals.winner = globals.decoded['winner'];
      globals.pressedPlayer1 = globals.decoded['p1_name'];
      globals.pressedPlayer2 = globals.decoded['p2_name'];
      globals.pressedSurface = globals.decoded['surface'];
    });
  }

  Widget _resultsBox() {
    return Container(
      width: _deviceWidth! * 0.90,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 244, 189),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: _deviceHeight! * 0.01,
                horizontal: _deviceWidth! * 0.02,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  globals.winner,
                  style: globals.winner.length > 20
                      ? const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        )
                      : const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(_deviceHeight! * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 226, 125, 134),
              ),
              child: Center(
                child: Text(
                  "${globals.percentage}%",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
