import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

class Spring with ChangeNotifier {
  final TickerProvider tickerProvider;
  Offset offset;

  Spring({required this.tickerProvider, required this.offset})
      : _tickerProvider = tickerProvider;

  final TickerProvider _tickerProvider;
  Ticker? _ticker;
  Offset velocity = Offset.zero;
  SpringSimulation? springX, springY;

  final SpringDescription springDesc = const SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: 6.0,
  );

  onSpringStart() {
    springX = SpringSimulation(springDesc, offset.dx, 0.0, velocity.dx);
    springY = SpringSimulation(springDesc, offset.dy, 0.0, velocity.dy);

    _ticker ??= _tickerProvider.createTicker(onTick);
    if (_ticker?.isActive == false) _ticker?.start();

    notifyListeners();
  }

  onTick(Duration elapsedTime) {
    final time = elapsedTime.inMilliseconds / 1000.0;

    offset = Offset(springX!.x(time), springY!.x(time));

    velocity = Offset(springX!.dx(time), springY!.dx(time));

    if (springY!.isDone(time) && springX!.isDone(time)) onSpringEnd();

    notifyListeners();
    // setState(() {});
  }

  onSpringEnd() {
    if (_ticker != null) _ticker?.stop();
  }
}
