import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef GestureOnTapChangeCallback = void Function(bool tapState);

extension StyledWidget on Widget {
  Widget parent(Widget Function({required Widget child}) parent) => parent(child: this);

  Widget padding({double? all, double? horizontal, double? vertical, double? top, double? bottom, double? left, double? right, bool animate = false}) =>
      Padding(padding: EdgeInsets.only(top: top ?? vertical ?? all ?? 0.0, bottom: bottom ?? vertical ?? all ?? 0.0, left: left ?? horizontal ?? all ?? 0.0, right: right ?? horizontal ?? all ?? 0.0), child: this);

  Widget backgroundColor(Color color, {bool animate = false}) => DecoratedBox(decoration: BoxDecoration(color: color), child: this);

  Widget clipRRect({double? all, double? topLeft, double? topRight, double? bottomLeft, double? bottomRight, CustomClipper<RRect>? clipper, Clip clipBehavior = Clip.antiAlias, bool animate = false}) => ClipRRect(
      clipper: clipper,
      clipBehavior: clipBehavior,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(topLeft ?? all ?? 0.0), topRight: Radius.circular(topRight ?? all ?? 0.0), bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0), bottomRight: Radius.circular(bottomRight ?? all ?? 0.0)),
      child: this);

  Widget clipRect({CustomClipper<Rect>? clipper, Clip clipBehavior = Clip.hardEdge}) => ClipRect(clipper: clipper, clipBehavior: clipBehavior, child: this);

  Widget clipOval() => ClipOval(child: this);

  Widget width(double width, {bool animate = false}) => ConstrainedBox(constraints: BoxConstraints.tightFor(width: width), child: this);

  Widget height(double height, {bool animate = false}) => ConstrainedBox(constraints: BoxConstraints.tightFor(height: height), child: this);

  Widget scrollable({Axis scrollDirection = Axis.vertical, bool reverse = false, bool? primary, ScrollPhysics? physics, ScrollController? controller, DragStartBehavior dragStartBehavior = DragStartBehavior.start}) =>
      SingleChildScrollView(scrollDirection: scrollDirection, reverse: reverse, primary: primary, physics: physics, controller: controller, dragStartBehavior: dragStartBehavior, child: this);

  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) => Flexible(flex: flex, fit: fit, child: this);

  Widget aspectRatio({required double aspectRatio}) => AspectRatio(aspectRatio: aspectRatio, child: this);

  Widget center({double? widthFactor, double? heightFactor}) => Center(widthFactor: widthFactor, heightFactor: heightFactor, child: this);

  Widget safeArea() => SafeArea(child: this);

  Widget inkwell({GestureTapCallback? onTap, Key? key}) => InkWell(
        key: key,
        onTap: onTap,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        child: this,
      );

  Widget gestures({
    GestureOnTapChangeCallback? onTapChange,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    GestureTapCallback? onTap,
    GestureTapCancelCallback? onTapCancel,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    GestureTapCancelCallback? onSecondaryTapCancel,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureLongPressUpCallback? onLongPressUp,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureDragDownCallback? onVerticalDragDown,
    GestureDragStartCallback? onVerticalDragStart,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onVerticalDragEnd,
    GestureDragCancelCallback? onVerticalDragCancel,
    GestureDragDownCallback? onHorizontalDragDown,
    GestureDragStartCallback? onHorizontalDragStart,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragCancelCallback? onHorizontalDragCancel,
    GestureDragDownCallback? onPanDown,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragEndCallback? onPanEnd,
    GestureDragCancelCallback? onPanCancel,
    GestureScaleStartCallback? onScaleStart,
    GestureScaleUpdateCallback? onScaleUpdate,
    GestureScaleEndCallback? onScaleEnd,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureForcePressEndCallback? onForcePressEnd,
    HitTestBehavior? behavior,
    bool excludeFromSemantics = false,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) =>
      GestureDetector(
        onTapDown: (TapDownDetails tapDownDetails) {
          if (onTapDown != null) onTapDown(tapDownDetails);
          if (onTapChange != null) onTapChange(true);
        },
        onTapCancel: () {
          if (onTapCancel != null) onTapCancel();
          if (onTapChange != null) onTapChange(false);
        },
        onTap: () {
          if (onTap != null) onTap();
          if (onTapChange != null) onTapChange(false);
        },
        onTapUp: onTapUp,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onLongPressStart: onLongPressStart,
        onLongPressEnd: onLongPressEnd,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        onLongPressUp: onLongPressUp,
        onVerticalDragStart: onVerticalDragStart,
        onVerticalDragEnd: onVerticalDragEnd,
        onVerticalDragDown: onVerticalDragDown,
        onVerticalDragCancel: onVerticalDragCancel,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onHorizontalDragStart: onHorizontalDragStart,
        onHorizontalDragEnd: onHorizontalDragEnd,
        onHorizontalDragCancel: onHorizontalDragCancel,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onHorizontalDragDown: onHorizontalDragDown,
        onForcePressStart: onForcePressStart,
        onForcePressEnd: onForcePressEnd,
        onForcePressPeak: onForcePressPeak,
        onForcePressUpdate: onForcePressUpdate,
        onPanStart: onPanStart,
        onPanEnd: onPanEnd,
        onPanCancel: onPanCancel,
        onPanDown: onPanDown,
        onPanUpdate: onPanUpdate,
        onScaleStart: onScaleStart,
        onScaleEnd: onScaleEnd,
        onScaleUpdate: onScaleUpdate,
        behavior: behavior,
        excludeFromSemantics: excludeFromSemantics,
        dragStartBehavior: dragStartBehavior,
        child: this,
      );
}
