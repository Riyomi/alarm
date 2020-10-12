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
  Timer _everySecond;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Text(_now,
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text(_date,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // sets first value
    var now = DateTime.now();
    _now = new DateFormat.Hms().format(now);
    _date = new DateFormat.yMMMMEEEEd().format(now);

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if(mounted) {
        setState(() {
          var now = DateTime.now();
          _now = new DateFormat.Hms().format(now);
          _date = new DateFormat.yMMMMEEEEd().format(now);
        });
      }
    });
  }
}