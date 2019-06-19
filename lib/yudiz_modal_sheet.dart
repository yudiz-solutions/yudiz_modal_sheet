import 'dart:async';

import 'package:flutter/material.dart';

@immutable
class YudizModalSheet extends StatefulWidget {
  final YudizModalSheetDirection direction;
  final Color backgroundColor;
  final Widget child;

  YudizModalSheet({this.child, this.direction, this.backgroundColor});

  @override
  _YudizModalSheetState createState() => _YudizModalSheetState();

  static show(
      {@required BuildContext context,
      @required child,
      direction = YudizModalSheetDirection.BOTTOM,
      backgroundColor = const Color(0xb3212121)}) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) {
              return YudizModalSheet(
                child: child,
                direction: direction,
                backgroundColor: backgroundColor,
              );
            },
            opaque: false));
  }
}

class _YudizModalSheetState extends State<YudizModalSheet>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  final GlobalKey _childKey = GlobalKey();

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      _animationController.status == AnimationStatus.reverse;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _animation = Tween<double>(begin: _isDirectionTop() ? -1 : 1, end: 0)
        .animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) Navigator.pop(context);
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) return;

    var change = details.primaryDelta / (_childHeight ?? details.primaryDelta);
    if (_isDirectionTop())
      _animationController.value += change;
    else
      _animationController.value -= change;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) return;

    if (details.velocity.pixelsPerSecond.dy > 0 && _isDirectionTop()) return;
    if (details.velocity.pixelsPerSecond.dy < 0 && !_isDirectionTop()) return;

    if (details.velocity.pixelsPerSecond.dy > 700) {
      final double flingVelocity =
          -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (_animationController.value > 0.0)
        _animationController.fling(velocity: flingVelocity);
    } else if (_animationController.value < 0.5) {
      if (_animationController.value > 0.0)
        _animationController.fling(velocity: -1.0);
    } else
      _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: onBackPressed,
        child: GestureDetector(
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: Scaffold(
            backgroundColor: widget.backgroundColor,
            body: SafeArea(
              child: Column(
                key: _childKey,
                children: <Widget>[
                  _isDirectionTop() ? Container() : Spacer(),
                  AnimatedBuilder(
                      animation: _animation,
                      builder: (context, _) {
                        return Transform(
                          transform: Matrix4.translationValues(
                              0.0, width * _animation.value, 0.0),
                          child: Container(
                            width: width,
                            child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {},
                                child: widget.child),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          excludeFromSemantics: true,
        ));
  }

  bool _isDirectionTop() {
    return widget.direction == YudizModalSheetDirection.TOP;
  }

  Future<bool> onBackPressed() {
    _animationController.reverse();
    return Future<bool>.value(false);
  }
}

enum YudizModalSheetDirection { TOP, BOTTOM }
