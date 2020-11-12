class Timer {
  int id;
  Duration duration;

  Timer({this.id, this.duration});

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'duration': this.duration.inSeconds,
      };
}
