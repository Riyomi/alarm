import 'dart:convert';

class Alarm {
  int id, hour, minute;
  bool isActive;

  Alarm({
    this.id,
    this.hour,
    this.minute,
    this.isActive,
  });

  factory Alarm.fromJson(Map<String, dynamic> jsonData) {
    return Alarm(
      id: jsonData['id'],
      hour: jsonData['hour'],
      minute: jsonData['minute'],
      isActive: jsonData['isActive'],
    );
  }

  static Map<String, dynamic> toMap(Alarm alarm) => {
        'id': alarm.id,
        'hour': alarm.hour,
        'minute': alarm.minute,
        'isActive': alarm.isActive,
      };

  static String encodeAlarms(List<Alarm> alarms) =>
      json.encode(
        alarms
            .map<Map<String, dynamic>>((alarm) => Alarm.toMap(alarm))
            .toList(),
      );

  static List<Alarm> decodeAlarms(String alarms) =>
      (json.decode(alarms) as List<dynamic>)
          .map<Alarm>((item) => Alarm.fromJson(item))
          .toList();
}
