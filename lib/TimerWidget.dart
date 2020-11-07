import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'CountDownTimer.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return TimersWithCarousel();
  }

  Widget addTimerWidget() {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.play_arrow_rounded),
            onPressed: () {
              print(convertStringToDuration(_text.padLeft(6, '0')));
            },
          ),
          visible: _text.length > 0 ? true : false,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 90),
            Text(formatTimer(_text.padLeft(6, '0')),
                style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
            NumericKeyboard(
              textColor: Colors.white,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              onKeyboardTap: _onKeyboardTap,
              rightIcon: Icon(Icons.backspace, color: Colors.white),
              rightButtonFn: () {
                setState(() {
                  if (_text.length > 0) {
                    _text = _text.substring(0, _text.length - 1);
                  }
                });
              },
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  _onKeyboardTap(String value) {
    setState(() {
      if (_text.length < 6) {
        if (!(value == '0' && _text.length == 0)) {
          _text += value;
        }
      }
    });
  }

  String formatTimer(String data) {
    return data.substring(0, 2) +
        ":" +
        data.substring(2, 4) +
        ":" +
        data.substring(4, 6);
  }

  Duration convertStringToDuration(String data) {
    int seconds = int.parse(data.substring(0, 2)) * 60 * 60 // hours
        +
        int.parse(data.substring(2, 4)) * 60 // minutes
        +
        int.parse(data.substring(4, 6)); // seconds
    return Duration(seconds: seconds);
  }
}

class TimersWithCarousel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimersWithCarouselState();
  }
}

class _TimersWithCarouselState extends State<TimersWithCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return CountDownTimer();
  }
}