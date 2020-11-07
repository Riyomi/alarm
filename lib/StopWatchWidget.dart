import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchWidget extends StatefulWidget {
  @override
  _StopwatchWidget createState() => _StopwatchWidget();
}

class _StopwatchWidget extends State<StopwatchWidget> {
  Duration _elapsedTime = Duration(microseconds: 0);
  Stopwatch _stopwatch = Stopwatch();
  bool _stopwatchStarted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 30),
        Text(format(_elapsedTime),
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
        ButtonBar(
          children: [
            ElevatedButton(
                child: Row(children: <Widget>[
                  //TODO: change the buttons to round ones without all this color bs (see Google's app as a reference)
                  _stopwatchStarted
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                  _stopwatchStarted ? Text('Pause') : Text('Start'),
                ]),
                style: _stopwatchStarted
                    ? ElevatedButton.styleFrom(primary: Colors.lime)
                    : ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  if (_stopwatchStarted) {
                    pauseStopwatch();
                  } else {
                    startStopwatch();
                  }
                  _stopwatchStarted = !_stopwatchStarted;
                }),
            ElevatedButton(
                child: Row(
                  children: [Icon(Icons.stop), Text('Reset')],
                ),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: resetStopwatch)
          ],
          alignment: MainAxisAlignment.center,
        ),
      ],
    );
  }

  startStopwatch() {
    _stopwatch.start();
    Timer.periodic(Duration(milliseconds: 10), (Timer t) {
      if (mounted) {
        setState(() {
          _elapsedTime = _stopwatch.elapsed;
        });
      }
    });
  }

  pauseStopwatch() {
    _stopwatch.stop();
  }

  resetStopwatch() {
    pauseStopwatch();
    _stopwatch.reset();
    _stopwatchStarted = false;
  }

  format(Duration d) => d.toString().substring(0, 10).padLeft(8, "0");

  // https://stackoverflow.com/questions/53228993/how-to-implement-persistent-stopwatch-in-flutter
}
