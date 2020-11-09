import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  String _now;
  String _date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 30),
          FittedBox(
              child: Text(_now,
                  style:
                      TextStyle(fontSize: 100, fontWeight: FontWeight.bold))),
          SizedBox(height: 10),
          FittedBox(
            child: Text(_date,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // sets first value
    var now = DateTime.now();
    _now = DateFormat.Hms().format(now);
    _date = DateFormat.yMMMMEEEEd().format(now);

    // defines a timer
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          var now = DateTime.now();
          _now = DateFormat.Hms().format(now);
          _date = DateFormat.yMMMMEEEEd().format(now);
        });
      }
    });
  }
}
