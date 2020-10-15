import 'package:flutter/material.dart';
import 'package:alarm/alarm_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmWidget extends StatefulWidget {
  @override
  _AlarmWidget createState() => _AlarmWidget();
}

class _AlarmWidget extends State<AlarmWidget> {
  List<Widget> alarms;
  List<Alarm> alarmsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: alarms != null ? alarms.length : 0,
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

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      if (prefs.getString('alarms') == null) {
        prefs.setString('alarms', Alarm.encodeAlarms([new Alarm(id: 0, hour: 8, minute: 30, isActive: true)]));
      } else {
        alarms = Alarm.createAlarmWidgets(Alarm.decodeAlarms(prefs.getString('alarms')));
      }
      setState(() {});
    });

  }
}