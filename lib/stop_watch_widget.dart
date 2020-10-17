import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchWidget extends StatefulWidget {
  @override
  _StopwatchWidget createState() => _StopwatchWidget();
}

class _StopwatchWidget extends State<StopwatchWidget> {
  Duration _elapsedTime;
  Stopwatch _stopwatch;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Text(format(_elapsedTime),
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
        RaisedButton(onPressed: startStopwatch),
        RaisedButton(onPressed: pauseStopwatch)
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _elapsedTime = Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0, microseconds: 0);
    _stopwatch = Stopwatch();
  }

  void startStopwatch() {
    _stopwatch.start();
    Timer.periodic(Duration(milliseconds: 10), (Timer t) {
      if(mounted) {
        setState(() {
          _elapsedTime = _stopwatch.elapsed;
        });
      }
    });
  }

  void pauseStopwatch() {
    _stopwatch.stop();
  }

  format(Duration d) => d.toString().substring(0,10).padLeft(8, "0");

  // https://stackoverflow.com/questions/53228993/how-to-implement-persistent-stopwatch-in-flutter
}