import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

Rect _visibleRect = Rect.zero;

abstract class CustomScrollPainter extends StatelessWidget {
  final Size size;
  final ScrollPhysics physics;

  CustomScrollPainter({
    this.size: Size.zero,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return new CustomScrollView(
      scrollDirection: Axis.horizontal,
      physics: physics,
      slivers: <Widget>[
        new CustomSliverToBoxAdapter(
          child: new CustomPaint(
            size: size,
            painter: new CustomRegionPainter(this),
          ),
        )
      ],
    );
  }

  void paint(Canvas canvas, Size size, Rect region);
}

class CustomSliverToBoxAdapter extends SingleChildRenderObjectWidget {
  const CustomSliverToBoxAdapter({
    Key key,
    Widget child,
  })
      : super(key: key, child: child);

  @override
  CustomRenderSliverToBoxAdapter createRenderObject(BuildContext context) =>
      new CustomRenderSliverToBoxAdapter();
}

class CustomRenderSliverToBoxAdapter extends RenderSliverSingleBoxAdapter {
  CustomRenderSliverToBoxAdapter({
    RenderBox child,
  })
      : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }
    assert(childExtent != null);
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = new SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child, constraints, geometry);

    switch (constraints.axis) {
      case Axis.horizontal:
        _visibleRect = new Rect.fromLTWH(constraints.scrollOffset, 0.0,
            geometry.paintExtent, child.size.height);
        break;
      case Axis.vertical:
        _visibleRect = new Rect.fromLTWH(0.0, constraints.scrollOffset,
            child.size.width, geometry.paintExtent);
        break;
    }
  }
}

class CustomRegionPainter extends CustomPainter {
  CustomScrollPainter _painter;

  CustomRegionPainter(this._painter);

  @override
  void paint(Canvas canvas, Size size) {
    _painter.paint(canvas, size, _visibleRect);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
