import 'package:alarm/CustomTimerPainter.dart';
import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final Duration duration;

  const CountDownTimer({Key key, this.duration}) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

//TODO: https://stackoverflow.com/questions/51029655/call-method-in-one-stateful-widget-from-another-stateful-widget-flutter

class _CountDownTimerState extends State<CountDownTimer>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    //  Duration duration = controller.duration * controller.value;
    if (widget.duration.inHours > 0) {
      return '${widget.duration.inHours % 24}:${widget.duration.inMinutes % 60}:${(widget.duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${widget.duration.inMinutes % 60}:${(widget.duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: CustomPaint(
                                    painter: CustomTimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.white,
                                  color: Colors.orange,
                                )),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      timerString,
                                      style: TextStyle(
                                          fontSize: 50.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) {
                          return FloatingActionButton(
                            onPressed: () {
                              if (controller.isAnimating)
                                controller.stop();
                              else {
                                controller.reverse(
                                    from: controller.value == 0.0
                                        ? 1.0
                                        : controller.value);
                              }
                            },
                            child: Icon(controller.isAnimating
                                ? Icons.pause
                                : Icons.play_arrow),
                          );
                        }),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
