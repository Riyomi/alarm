import 'package:flutter/material.dart';
import 'package:alarm/alarm_class.dart';

class AlarmWidget extends StatefulWidget {
  @override
  _AlarmWidget createState() => _AlarmWidget();
}

class _AlarmWidget extends State<AlarmWidget> {
  List<Widget> alarms;
  List<Alarm> alarmsList;
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    alarms = _createChildren();
    return ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              alarms[index],
              Divider(
                color: Colors.white54,
              ),
            ],
          );
        }
    );
  }
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _createChildren() {
    return <Widget>[
      Container(
        child: Row(
          children: [
            Text('08:10',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Switch(
              value: _value,
              onChanged: (value){
                setState(() {
                  _value=value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
      Container(
        child: Row(
          children: [
            Text('08:10',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Switch(
              value: _value,
              onChanged: (value){
                setState(() {
                  _value=value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
      Container(
        child: Row(
          children: [
            Text('08:10',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Switch(
              value: _value,
              onChanged: (value){
                setState(() {
                  _value=value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    ];
  }
}