class Alarm {
  int id, hour, minute;
  bool isActive;

  Alarm({
    this.id,
    this.hour,
    this.minute,
    this.isActive,
  });

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'hour': this.hour,
        'minute': this.minute,
        'isActive': this.isActive ? 1 : 0,
      };
}
