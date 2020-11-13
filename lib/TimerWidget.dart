import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

import 'CountDownTimer.dart';
import 'DataBaseHandler.dart';
import 'Timer.dart';

class TimerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerWidgetState();
  }
}

class _TimerWidgetState extends State<TimerWidget> {
  int _current = 0;
  bool _displayAddPage = true;
  List<CountDownTimer> _countDownTimers = List<CountDownTimer>();
  List<Timer> _timers;
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return _displayAddPage ? addNewTimerScaffold : timersWithCarousel;
  }

  @override
  void initState() {
    super.initState();
    initializeTimers();
  }

  Future<void> initializeTimers() async {
    await getTimers().then((value) => {
          _timers = value,
          if (_timers.isNotEmpty)
            {
              _displayAddPage = false,
              _countDownTimers = List<CountDownTimer>(),
              for (Timer timer in _timers)
                {
                  _countDownTimers.add(CountDownTimer(duration: timer.duration))
                },
            }
          else
            {_displayAddPage = true},
          setState(() {})
        });
  }

  Future<void> addNewTimer(Duration duration) async {
    await insertTimer(Timer(duration: duration))
        .then((value) => initializeTimers());
  }

  Future<void> removeTimer(Timer timer) async {
    await deleteTimer(timer).then((value) => initializeTimers());
  }

  Widget get timersWithCarousel {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow_outlined),
        onPressed: () {},
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            CarouselSlider(
              items: _countDownTimers,
              options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  enableInfiniteScroll: false),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _countDownTimers.map((url) {
                int index = _countDownTimers.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
            Spacer(),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0, left: 20.0, bottom: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: FlatButton(
                              onPressed: () {
                                _countDownTimers.removeAt(_current);
                                removeTimer(_timers[_current]);
                              },
                              child: Text('Delete'))),
                      Spacer(),
                      Expanded(
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  _displayAddPage = true;
                                });
                              },
                              child: Text('Add a timer'))),
                    ],
                  ),
                )),
          ]),
    );
  }

  Widget get addNewTimerScaffold {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: Icon(Icons.play_arrow_outlined),
            onPressed: () {
              addNewTimer(stringAsDuration);
              _text = '';
            },
          ),
          visible: _text.length > 0 ? true : false,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 90),
            Text(timerString,
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
            Visibility(
              visible: _countDownTimers.isNotEmpty,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _displayAddPage = false;
                                    _text = "";
                                  });
                                },
                                child: Text('Cancel'))),
                        Spacer(),
                      ],
                    ),
                  )),
            ),
          ],
        ));
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

  String get timerString {
    return _text.padLeft(6, '0').substring(0, 2) +
        ":" +
        _text.padLeft(6, '0').substring(2, 4) +
        ":" +
        _text.padLeft(6, '0').substring(4, 6);
  }

  Duration get stringAsDuration {
    int seconds =
        int.parse(_text.padLeft(6, '0').substring(0, 2)) * 60 * 60 // hours
            +
            int.parse(_text.padLeft(6, '0').substring(2, 4)) * 60 // minutes
            +
            int.parse(_text.padLeft(6, '0').substring(4, 6)); // seconds
    return Duration(seconds: seconds);
  }
}
