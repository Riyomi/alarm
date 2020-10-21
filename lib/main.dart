import 'dart:isolate';
import 'dart:ui';
import 'package:alarm/stop_watch_widget.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:alarm/alarm_widget.dart';
import 'package:alarm/clock_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'alarm_class.dart';

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
    await prefs.setString('alarms', Alarm.encodeAlarms([Alarm(id: 0, hour: 15, minute: 27, isActive: false)]));
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
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        backgroundColor: Colors.black12,
      )
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
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    AlarmsWidget(),
    ClockWidget(),
    StopwatchWidget(),
    Text('Index 3: Timer', style: optionStyle),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
      switch(index) {
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
        backgroundColor: Colors.black12,
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

Widget _simplePopup() => PopupMenuButton<int>(
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 1,
      child: Text("Settings"),
    ),
  ],
);
