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
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController _textController;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours % 24}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      value: 1,
      vsync: this,
      duration: widget.duration,
    );
    _textController = AnimationController(
        value: 1, vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    controller.dispose();
    _textController.dispose();
    super.dispose();
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
                                      backgroundColor: Colors.orange,
                                      color: Colors.white,
                                )),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        if (controller.isAnimating) {
                                          controller.stop();
                                          _textController.repeat(reverse: true);
                                        } else {
                                          _textController.stop();
                                          _textController.value = 1;
                                          controller.reverse(
                                              from: controller.value == 0.0
                                                  ? 1.0
                                                  : controller.value);
                                        }
                                      },
                                      child: FadeTransition(
                                        opacity: _textController,
                                        child: Text(
                                          timerString,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
