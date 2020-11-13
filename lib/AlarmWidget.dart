import 'dart:math';
import 'dart:ui';

import 'package:alarm/Alarm.dart';
import 'package:alarm/main.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'DataBaseHandler.dart';

class AlarmsWidget extends StatefulWidget {
  @override
  _AlarmsWidget createState() => _AlarmsWidget();
}

class _AlarmsWidget extends State<AlarmsWidget> {
  List<Widget> alarmWidgets;
  List<Alarm> alarms;

  @override
  Widget build(BuildContext context) {
    List<Widget> alarmsCopy = List<Widget>();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Future<TimeOfDay> selectedTime = showTimePicker(
            initialTime: TimeOfDay.now(),
            context: context,
            builder: (BuildContext context, Widget child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              );
            },
          );
          selectedTime.then((time) => {addNewAlarm(time.hour, time.minute)});
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: alarmWidgets != null ? alarmWidgets.length : 0,
            itemBuilder: (context, index) {
              final alarmWidget = alarmWidgets[index];
              final alarm = alarms[index];
              return Column(
                children: <Widget>[
                  Dismissible(
                      key: Key(alarmWidget.hashCode.toString()),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          Future<TimeOfDay> selectedTime = showTimePicker(
                            initialTime: TimeOfDay(
                                hour: alarm.hour, minute: alarm.minute),
                            context: context,
                            builder: (BuildContext context, Widget child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child,
                              );
                            },
                          );
                          selectedTime.then((time) => {
                                if (time == null)
                                  {modifyAlarm(alarm, alarm.hour, alarm.minute)}
                                else
                                  {modifyAlarm(alarm, time.hour, time.minute)}
                              });
                        } else {
                          setState(() {
                            alarmsCopy.addAll(alarmWidgets);
                            alarmWidgets.removeAt(index);
                          });
                          Scaffold
                              .of(context)
                              .showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Alarm deleted"),
                              action: SnackBarAction(
                                  label: "UNDO",
                                  onPressed: () {
                                    setState(() {
                                      alarmWidgets = alarmsCopy;
                                    });
                                  })))
                              .closed
                              .then((SnackBarClosedReason reason) {
                            if (reason != SnackBarClosedReason.action) {
                              removeAlarm(alarm);
                            }
                          });
                        }
                      },
                      background: modifyBackground(),
                      secondaryBackground: deleteBackground(),
                      child: alarmWidgets[index]),
                  Divider(color: Colors.white54)
                ],
              );
            }),
      ),
    );
  }

  Future<void> addNewAlarm(int hour, int minute) async {
    await insertAlarm(Alarm(hour: hour, minute: minute, isActive: false))
        .then((value) =>
    {
      getAlarms().then((value) =>
      {
        alarms = value,
        alarmWidgets = createAlarmWidgets(alarms),
        setState(() {})
      })
    });
  }

  Future<void> removeAlarm(Alarm alarm) async {
    await deleteAlarm(alarm).then((value) =>
    {
      getAlarms().then((value) =>
      {
        alarms = value,
        alarmWidgets = createAlarmWidgets(alarms),
        setState(() {})
      })
    });
  }

  Future<void> modifyAlarm(Alarm alarm, int hour, int minute) async {
    await updateAlarm(Alarm(
        id: alarm.id, hour: hour, minute: minute, isActive: alarm.isActive))
        .then((value) =>
    {
      getAlarms().then((value) =>
      {
        alarms = value,
        alarmWidgets = createAlarmWidgets(alarms),
        setState(() {})
      })
    });
  }

  Widget deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Widget modifyBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      color: Colors.lime,
      child: Icon(
        Icons.update,
        color: Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeAlarms();
  }

  Future<void> initializeAlarms() async {
    await getAlarms().then((value) => {
          alarms = value,
          alarmWidgets = createAlarmWidgets(alarms),
          setState(() {})
        });
  }

  List<Widget> createAlarmWidgets(List<Alarm> alarms) {
    List<Widget> widgets = List<Widget>();
    if (alarms == null) {
      return null;
    }
    for (Alarm alarm in alarms) {
      widgets.add(AlarmWidget(
          id: alarm.id,
          hour: alarm.hour,
          minute: alarm.minute,
          isActive: alarm.isActive));
    }
    return widgets;
  }
}

class AlarmWidget extends StatefulWidget {
  final int id, hour, minute;
  final bool isActive;

  @override
  _AlarmWidget createState() => _AlarmWidget();

  AlarmWidget({Key key, this.id, this.hour, this.minute, this.isActive})
      : super(key: key);
}

class _AlarmWidget extends State<AlarmWidget> {
  TimeOfDay _time;
  bool _isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(convertTimeOfDay(_time),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
                if (_isActive) {
                  DateTime now = DateTime.now();
                  setAlarm(
                      now.year, now.month, now.day, _time.hour, _time.minute);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Alarm set to ' + convertTimeOfDay(_time)),
                    duration: Duration(seconds: 2),
                  ));
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
    _time = TimeOfDay(hour: widget.hour, minute: widget.minute);
    _isActive = widget.isActive;
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

  Future<void> setAlarm(int year, int month, int day, int hour,
      int minute) async {
    await AndroidAlarmManager.oneShotAt(
        DateTime(year, month, day, hour, minute),
        Random().nextInt(pow(2, 31)), // Ensure we have a unique alarm ID.
        callback,
        exact: true,
        wakeup: true);
  }

  String convertTimeOfDay(TimeOfDay timeOfDay) {
    return timeOfDay.hour.toString().padLeft(2, '0') +
        ':' +
        timeOfDay.minute.toString().padLeft(2, '0');
  }
}
