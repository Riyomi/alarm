import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:alarm/alarm_class.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:alarm/main.dart';

class AlarmsWidget extends StatefulWidget {
  @override
  _AlarmsWidget createState() => _AlarmsWidget();
}

class _AlarmsWidget extends State<AlarmsWidget> {
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
     alarms = createAlarmWidgets(Alarm.decodeAlarms(prefs.getString('alarms')));
     setState(() {});
  }

  List<Widget> createAlarmWidgets(List<Alarm> alarms) {
    List<Widget> widgets = List<Widget>();
    for (Alarm alarm in alarms) {
      widgets.add(AlarmWidget(hour: alarm.hour, minute: alarm.minute, isActive: alarm.isActive));
    }
    return widgets;
  }
}

class AlarmWidget extends StatefulWidget {
  final int hour, minute;
  final bool isActive;
  @override
  _AlarmWidget createState() => _AlarmWidget();

  AlarmWidget({Key key, this.hour, this.minute, this.isActive}): super(key: key);
}

class _AlarmWidget extends State<AlarmWidget> {
  int _hour;
  int _minute;
  bool _isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(_hour.toString() + ":" + _minute.toString(),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          Switch(
            value: _isActive,
            onChanged: (value){
              setState(() {
                _isActive=value;
                if (_isActive) {
                  DateTime now = new DateTime.now();
                  setAlarm(now.year, now.month, now.day, _hour, _minute);
                  print('Alarm set !');
                }
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _hour = widget.hour;
    _minute = widget.minute;
    _isActive =widget.isActive;
  }

  static Future<void> callback() async {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false,
      asAlarm: true, // Android only - all APIs
    );
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  Future<void> setAlarm(int year, int month, int day, int hour, int minute) async {
    await AndroidAlarmManager.oneShotAt(
        DateTime(year, month, day, hour, minute),
        // Ensure we have a unique alarm ID.
        Random().nextInt(pow(2, 31)),
        callback,
        exact: true,
        wakeup: true);
  }

}