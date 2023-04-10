library circle_list;

import 'dart:math';

import 'package:circle_list/radial_drag_gesture_detector.dart';
export 'package:circle_list/radial_drag_gesture_detector.dart';
import 'package:flutter/material.dart';

class CircleList extends StatefulWidget {
  final double? innerRadius;
  final double? outerRadius;
  final double childrenPadding;
  final double initialAngle;
  final double wedgeAngle;
  final double offsetAngle;
  final int activeChild;
  final Color? outerCircleColor;
  final Color? innerCircleColor;
  final Gradient? gradient;
  final Offset? origin;
  final List<Widget> children;
  final bool isChildrenVertical;
  final RotateMode? rotateMode;
  final bool innerCircleRotateWithChildren;
  final bool showInitialAnimation;
  final Widget? centerWidget;
  final RadialDragStart? onDragStart;
  final RadialDragUpdate? onDragUpdate;
  final RadialDragEnd? onDragEnd;
  final AnimationSetting? animationSetting;
  final DragAngleRange? dragAngleRange;

  CircleList({
    this.innerRadius,
    this.outerRadius,
    this.childrenPadding = 10,
    this.initialAngle = 0,
    this.wedgeAngle = 0,
    this.offsetAngle = 0,
    this.activeChild = 0,
    this.outerCircleColor,
    this.innerCircleColor,
    this.origin,
    required this.children,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.gradient,
    this.centerWidget,
    this.isChildrenVertical = true,
    this.innerCircleRotateWithChildren = false,
    this.showInitialAnimation = false,
    this.animationSetting,
    this.rotateMode,
    this.dragAngleRange,
  });

  @override
  _CircleListState createState() => _CircleListState();
}

class _CircleListState extends State<CircleList>
    with SingleTickerProviderStateMixin {
  _DragModel dragModel = _DragModel();
  AnimationController? _controller;
  late Animation<double> _animationRotate;
  bool isAnimationStop = true;

  @override
  void initState() {
    if (widget.showInitialAnimation) {
      _controller = AnimationController(
          vsync: this,
          duration: widget.animationSetting?.duration ?? Duration(seconds: 1));
      _animationRotate = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _controller!,
          curve: widget.animationSetting?.curve ?? Curves.easeOutBack));
      _controller!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isAnimationStop = true;
          });
        }
      });
      _controller!.addListener(() {
        setState(() {
          isAnimationStop = false;
        });
      });
      _controller!.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final outCircleDiameter = min(size.width, size.height);
    final double outerRadius = widget.outerRadius ?? outCircleDiameter / 2;
    final double innerRadius = widget.innerRadius ?? outerRadius / 2;
    final double betweenRadius = (outerRadius + innerRadius) / 2;
    final rotateMode = widget.rotateMode ?? RotateMode.onlyChildrenRotate;
    final dragAngleRange = widget.dragAngleRange;

    ///the origin is the point to left and top
    final Offset origin = widget.origin ?? Offset(0, -outerRadius);
    double backgroundCircleAngle = 0.0;
    if (rotateMode == RotateMode.allRotate) {
      backgroundCircleAngle = dragModel.angleDiff + widget.initialAngle;
    }

    return Container(
      width: outerRadius * 2,
      height: outerRadius * 2,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: origin.dx,
            top: -origin.dy,
            child: RadialDragGestureDetector(
              stopRotate: rotateMode == RotateMode.stopRotate,
              onRadialDragUpdate: (PolarCoord updateCoord) {
                if (widget.onDragUpdate != null) {
                  widget.onDragUpdate!(updateCoord);
                }
                setState(() {
                  dragModel.getAngleDiff(updateCoord, dragAngleRange);
                });
              },
              onRadialDragStart: (PolarCoord startCoord) {
                if (widget.onDragStart != null) {
                  widget.onDragStart!(startCoord);
                }
                setState(() {
                  dragModel.start = startCoord;
                });
              },
              onRadialDragEnd: () {
                if (widget.onDragEnd != null) {
                  widget.onDragEnd!();
                }
                dragModel.end = dragModel.start;
                dragModel.end!.angle = dragModel.angleDiff;
              },
              child: Transform.rotate(
                angle: backgroundCircleAngle,
                child: Container(
                    width: outerRadius * 2,
                    height: outerRadius * 2,
                    decoration: BoxDecoration(
                        gradient: widget.gradient,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.outerCircleColor ??
                              Color.fromARGB(0, 227, 22, 22),
                          width: outerRadius - innerRadius,
                        ))),
              ),
            ),
          ),
          Positioned(
            left: -75,
            //  origin.dx,
            top: origin.dy,
            child: Container(
              width: outerRadius * 2,
              height: outerRadius * 2,
              child: RadialDragGestureDetector(
                stopRotate: rotateMode == RotateMode.stopRotate,
                onRadialDragUpdate: (PolarCoord updateCoord) {
                  if (widget.onDragUpdate != null) {
                    widget.onDragUpdate!(updateCoord);
                  }
                  setState(() {
                    dragModel.getAngleDiff(updateCoord, dragAngleRange);
                  });
                },
                onRadialDragStart: (PolarCoord startCoord) {
                  if (widget.onDragStart != null) {
                    widget.onDragStart!(startCoord);
                  }
                  setState(() {
                    dragModel.start = startCoord;
                  });
                },
                onRadialDragEnd: () {
                  if (widget.onDragEnd != null) {
                    widget.onDragEnd!();
                  }
                  dragModel.end = dragModel.start;
                  dragModel.end!.angle = dragModel.angleDiff;
                },
                child: Transform.rotate(
                  angle: widget.rotateMode == RotateMode.stopRotate
                      ? widget.initialAngle
                      : isAnimationStop
                          ? (dragModel.angleDiff + widget.initialAngle)
                          : (-_animationRotate.value * pi * 2 +
                              widget.initialAngle),
                  child: Stack(
                      children: List.generate(widget.children.length, (index) {
                    final double childrenDiameter =
                        2 * pi * betweenRadius / widget.children.length -
                            widget.childrenPadding;
                    Offset childPoint = getChildPoint(
                        index,
                        widget.children.length,
                        betweenRadius,
                        childrenDiameter);
                    Offset arcPoint = getArcPoints(
                        index,
                        widget.children.length,
                        betweenRadius,
                        childrenDiameter);
                    return Positioned(
                      left: outerRadius + childPoint.dx,
                      top: outerRadius + childPoint.dy,
                      child: Transform.rotate(
                          angle: widget.rotateMode == RotateMode.stopRotate
                              ? widget.initialAngle
                              : widget.isChildrenVertical
                                  ? (-(dragModel.angleDiff) -
                                      widget.initialAngle)
                                  : ((dragModel.angleDiff) +
                                      widget.initialAngle),
                          child: Container(
                            width: childrenDiameter,
                            height: childrenDiameter,
                            alignment: Alignment.center,
                            child: widget.activeChild == index
                                ? Stack(
                                    children: [
                                      CustomPaint(
                                        size: Size(100, 100),
                                        painter: ArcPainter(
                                            arcPoint.dx, (90 * (pi / 180))),
                                      ),
                                      widget.children[index],
                                    ],
                                  )
                                : widget.children[index],
                          )),
                    );
                  })),
                ),
              ),
            ),
          ),
          Positioned(
              left: 15,
              //  origin.dx + outerRadius - innerRadius,
              top: 75,
              // -origin.dy + outerRadius - innerRadius,
              child: Transform.rotate(
                angle: widget.innerCircleRotateWithChildren
                    ? dragModel.angleDiff + widget.initialAngle
                    : 0,
                child: Container(
                  width: innerRadius * 2,
                  height: innerRadius * 2,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.innerCircleColor ??
                        Color.fromARGB(0, 240, 35, 35),
                  ),
                  child: widget.centerWidget ?? SizedBox(),
                ),
              ))
        ],
      ),
    );
  }

  Offset getChildPoint(
      int index, int length, double betweenRadius, double childrenDiameter) {
    double angle = 2 * pi * (index / length);
    double wedgeAngle = widget.wedgeAngle * (pi / 180) * index;
    if (angle > wedgeAngle && wedgeAngle > 0) {
      angle = wedgeAngle;
    }
    angle = angle + (widget.offsetAngle * (pi / 180));
    double x = cos(angle) * betweenRadius - childrenDiameter / 2;
    double y = sin(angle) * betweenRadius - childrenDiameter / 2;
    return Offset(x, y);
  }

  Offset getArcPoints(
      int index, int length, double betweenRadius, double childrenDiameter) {
    double angle = 2 * pi * (index / length);
    double wedgeAngle = widget.wedgeAngle * (pi / 180) * index;
    if (angle > wedgeAngle && wedgeAngle > 0) {
      angle = wedgeAngle;
    }
    angle = angle + dragModel.angleDiff + (widget.offsetAngle * (pi / 180));
    double startAngle = angle + (-45 * (pi / 180));
    double endAngle = angle + (45 * (pi / 180));
    return Offset(startAngle, endAngle);
  }
}

class _DragModel {
  PolarCoord? start;
  PolarCoord? end;
  double angleDiff = 0.0;

  double getAngleDiff(PolarCoord updatePolar, DragAngleRange? dragAngleRange) {
    if (start != null) {
      angleDiff = updatePolar.angle - start!.angle;
      if (end != null) {
        angleDiff += end!.angle;
      }
    }
    angleDiff = limitAngle(angleDiff, dragAngleRange);
    return angleDiff;
  }

  double limitAngle(double angleDiff, DragAngleRange? dragAngleRange) {
    if (dragAngleRange == null) return angleDiff;
    if (angleDiff > dragAngleRange.end) angleDiff = dragAngleRange.end;
    if (angleDiff < dragAngleRange.start) angleDiff = dragAngleRange.start;
    return angleDiff;
  }
}

class AnimationSetting {
  final Duration? duration;
  final Curve? curve;

  AnimationSetting({this.duration, this.curve});
}

class ArcPainter extends CustomPainter {
  double startAngle;
  double sweepAngle;
  ArcPainter(this.startAngle, this.sweepAngle);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(179, 29, 16, 71)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(-3, 0, size.width, size.height);

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
