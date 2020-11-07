import 'dart:isolate';
import 'dart:ui';
import 'package:alarm/StopWatchWidget.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:alarm/AlarmWidget.dart';
import 'package:alarm/ClockWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alarm/Alarm.dart';
import 'package:alarm/TimerWidget.dart';

SendPort uiSendPort;
const String isolateName = 'isolate';
final ReceivePort port = ReceivePort();

SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidAlarmManager.initialize();

  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('alarms')) {
    await prefs.setString(
        'alarms',
        Alarm.encodeAlarms(
            [Alarm(id: 0, hour: 15, minute: 27, isActive: false)]));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Clock';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(),
      theme:
          ThemeData(primarySwatch: Colors.orange, brightness: Brightness.light),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        snackBarTheme: SnackBarThemeData(backgroundColor: Colors.white54),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white54,
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  String _appBarTitle = 'Alarm';
  List<Widget> _widgetOptions = <Widget>[
    AlarmsWidget(),
    ClockWidget(),
    StopwatchWidget(),
    TimerWidget(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _appBarTitle = 'Alarm';
          break;
        case 1:
          _appBarTitle = 'Clock';
          break;
        case 2:
          _appBarTitle = 'Stopwatch';
          break;
        case 3:
          _appBarTitle = 'Timer';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        centerTitle: true,
        actions: [
          _simplePopup(),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty),
            label: 'Stopwatch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white38,
        selectedItemColor: Colors.amber[800],
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget _simplePopup() =>
    PopupMenuButton<int>(
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          value: 1,
          child: Text("Settings"),
        ),
      ],
    );
