import 'package:flutter/material.dart';
import 'package:selector/CustomScrollPainter.dart';

const tickSpacing = 20.0;

class Tape extends CustomScrollPainter {
  double minValue;
  double maxValue;
  int divisions;

  Paint _largeTickPaint = new Paint();
  Paint _smallTickPaint = new Paint();

  Tape({
    this.minValue: 0.0,
    this.maxValue: 100.0,
    this.divisions: 5,
  })
      : super(
          size: new Size(_computeSize(minValue, maxValue, divisions), 60.0),
        ) {
    _largeTickPaint.color = Colors.black;
    _largeTickPaint.strokeWidth = 2.0;

    _smallTickPaint.color = Colors.black;
    _smallTickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size, Rect region) {
    var rect = Offset.zero & size;

    // Extend drawing window to compensate for element sizes
    var extend = _largeTickPaint.strokeWidth / 2.0;

    // Calculate from which Tick we should start drawing
    var tick = ((region.left - extend) / tickSpacing).ceil();

    var startOffset = tick * tickSpacing;
    var o1 = new Offset(startOffset, 0.0);
    var o2 = new Offset(startOffset, rect.height);

    while (o1.dx < region.right + extend) {
      Paint p = tick % divisions == 0 ? _largeTickPaint : _smallTickPaint;

      canvas.drawLine(o1, o2, p);
      o1 = o1.translate(tickSpacing, 0.0);
      o2 = o2.translate(tickSpacing, 0.0);

      tick++;
    }
  }
}

double _computeSize(double minValue, double maxValue, int divisions) {
  return (maxValue - minValue) * divisions * tickSpacing;
}
