import 'dart:math';

import 'package:flutter/material.dart';

typedef Future OnTap();

class AnimatedButton extends StatefulWidget {
  final String loginTip;
  final double width, height;
  final double indicatorStarRadian;
  final double indicatorWidth;
  final Color buttonColorNormal;
  final Color buttonColorError;
  final Color indicatorColor;
  final TextStyle textStyleNormal;
  final TextStyle textStyleError;
  final OnTap onTap;
  final LoginErrorMessageController loginErrorMessageController;
  final Duration showErrorTime;

  AnimatedButton({
    this.height: 40.0,
    this.width: 200.0,
    this.loginTip: "Button",
    this.indicatorStarRadian: 0.0,
    this.indicatorWidth: 2.0,
    this.buttonColorNormal: Colors.white,
    this.buttonColorError: Colors.white,
    this.indicatorColor: Colors.black26,
    this.textStyleNormal: const TextStyle(fontSize: 16.0, color: Colors.orangeAccent),
    this.textStyleError: const TextStyle(fontSize: 16.0, color: Colors.black26),
    @required this.onTap,
    this.loginErrorMessageController,
    this.showErrorTime: const Duration(milliseconds: 2000),
  });

  @override
  State<StatefulWidget> createState() {
    return new AnimatedButtonState();
  }
}

class AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin<AnimatedButton> {
  Animation<double> animationStart;
  AnimationController controllerStart;

  Animation<double> animationEnd;
  AnimationController controllerEnd;

  Animation<double> animationRecover;
  AnimationController controllerRecover;

  AnimationController animationControllerWait;
  double widgetWidth, widgetHeight;
  bool isReset = false;
  bool isNeedRecoverLoginState = false;

  Color _buttonColor;
  String _loginTextTip;
  double _recoverCircleRadius = 0.0;
  TextStyle _textStyle;
  bool _isInAnimation = false;
  bool _assumeLoadFail = false;

  @override
  void initState() {
    super.initState();
    if (widget.loginErrorMessageController != null) {
      widget.loginErrorMessageController.loginState = this;
    }
    widgetWidth = widget.width;
    widgetHeight = widget.height;
    _buttonColor = widget.buttonColorNormal;
    _loginTextTip = widget.loginTip;
    _textStyle = widget.textStyleNormal;

    animationControllerWait = new AnimationController(
        duration: const Duration(milliseconds: 1000 * 100), vsync: this);

    controllerStart = new AnimationController(
        duration: const Duration(milliseconds: 380), vsync: this);
    controllerEnd = new AnimationController(
        duration: const Duration(milliseconds: 380), vsync: this);
    controllerRecover = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    initAnimationStart();
    initAnimationEnd();
    initAnimationRecover();
  }

  void changeErrorMsg(String msg) {
    if (mounted) {
      setState(() {
        _assumeLoadFail = true;
        _loginTextTip = msg;
        _textStyle = widget.textStyleError;
        _buttonColor = widget.buttonColorError;
      });
    }
  }

  void initAnimationRecover() {
    animationRecover =
        new Tween(begin: 0.0, end: widgetWidth).animate(controllerRecover)
          ..addListener(() {
            if (mounted) {
              setState(() {
                _recoverCircleRadius = animationRecover.value;
              });
            }
          });

    animationRecover.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        isNeedRecoverLoginState = false;
        _loginTextTip = widget.loginTip;
        _textStyle = widget.textStyleNormal;
        _buttonColor = widget.buttonColorNormal;
        controllerRecover.reset();
        _isInAnimation = false;
      } else if (animationStatus == AnimationStatus.forward) {
        isNeedRecoverLoginState = true;
      }
    });
  }

  void initAnimationStart() {
    animationStart = new Tween(begin: widgetWidth, end: widgetHeight)
        .animate(controllerStart)
          ..addListener(() {
            if (isReset) {
              return;
            }
            if (mounted) {
              setState(() {
                widgetWidth = animationStart.value;
              });
            }
          });

    animationStart.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        isReset = true;
        controllerStart.reset();
        isReset = false;
        animationControllerWait.forward();
        handleAnimationEnd();
      } else if (animationStatus == AnimationStatus.forward) {}
    });
  }

  void initAnimationEnd() {
    animationEnd =
        new Tween(begin: widgetHeight, end: widget.width).animate(controllerEnd)
          ..addListener(() {
            if (isReset) {
              return;
            }
            if (mounted) {
              setState(() {
                widgetWidth = animationEnd.value;
              });
            }
          });

    animationEnd.addStatusListener((animationStatus) async {
      if (animationStatus == AnimationStatus.completed) {
        isReset = true;
        controllerEnd.reset();
        isReset = false;
        await Future.delayed(widget.showErrorTime);
        if (mounted) {
          controllerRecover.forward();
        }
      } else if (animationStatus == AnimationStatus.forward) {}
    });
  }

  void handleAnimationEnd() async {
    _assumeLoadFail = false;
    await widget.onTap();
    if (mounted && _assumeLoadFail) {
      animationControllerWait.stop();
      animationControllerWait.reset();
      controllerEnd.forward();
    }
  }

  @override
  void dispose() {
    controllerStart.dispose();
    animationControllerWait.dispose();
    controllerRecover.dispose();
    controllerEnd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new RotationTransition(
        child: new CustomPaint(
          size: new Size(widgetWidth, widgetHeight),
          painter: new LoginPainter(
            width: widgetWidth,
            height: widgetHeight,
            recoverText: widget.loginTip,
            indicatorStarRadian: widget.indicatorStarRadian,
            indicatorWidth: widget.indicatorWidth,
            buttonColorShow: _buttonColor,
            indicatorColor: widget.indicatorColor,
            recoverTextStyle: widget.textStyleNormal,
            recoverButtonColor: widget.buttonColorNormal,
            isNeedRecoverLoginState: isNeedRecoverLoginState,
            recoverCircleRadius: _recoverCircleRadius,
            showText: _loginTextTip,
            showTextStyle: _textStyle,
          ),
        ),
        turns:
            new Tween(begin: 0.0, end: 150.0).animate(animationControllerWait)
              ..addStatusListener((animationStatus) {
                if (animationStatus == AnimationStatus.completed) {
                  animationControllerWait.repeat();
                }
              }),
      ),
      onTap: () {
        if (!_isInAnimation) {
          _isInAnimation = true;
          controllerStart.forward();
        }
      },
    );
  }
}

class LoginPainter extends CustomPainter {
  final double width, height;
  final String recoverText;
  final double indicatorRadian = 4.71238898038469;
  final double indicatorStarRadian;

  final double indicatorWidth;
  double isoscelesTriangle;

  final Color indicatorColor;
  final TextStyle recoverTextStyle;
  final bool isNeedRecoverLoginState;
  final Color recoverButtonColor;
  final Color buttonColorShow;
  final double recoverCircleRadius;
  final String showText;
  final TextStyle showTextStyle;

  LoginPainter({
    this.width,
    this.height,
    this.recoverText,
    this.indicatorStarRadian,
    this.indicatorWidth,
    this.recoverButtonColor,
    this.buttonColorShow,
    this.indicatorColor,
    this.recoverTextStyle,
    this.isNeedRecoverLoginState,
    this.recoverCircleRadius,
    this.showText,
    this.showTextStyle,
  }) {
    isoscelesTriangle = indicatorWidth * 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();
    paint.color = buttonColorShow;
    double halfHeight = height / 2;
    if (height < width) {
      drawCornerButton(canvas, paint, halfHeight, showText, showTextStyle);
    } else {
      drawCircleButton(canvas, paint, halfHeight);
    }

    if (isNeedRecoverLoginState) {
      paint.color = recoverButtonColor;
      Paint layerPaint = Paint();
      canvas.saveLayer(
          new Rect.fromLTWH(0.0, 0.0, recoverCircleRadius, size.height),
          layerPaint);
      drawCornerButton(
          canvas, paint, halfHeight, recoverText, recoverTextStyle);

      layerPaint.blendMode = BlendMode.dstIn;

      canvas.saveLayer(
          new Rect.fromLTWH(0.0, 0.0, recoverCircleRadius, size.height),
          layerPaint);
      canvas.drawCircle(new Offset(0.0, 0.0), recoverCircleRadius, paint);
      canvas.restore();
      canvas.restore();
    }
  }

  void drawCircleButton(Canvas canvas, Paint paint, double halfHeight) {
    canvas.drawCircle(new Offset(halfHeight, halfHeight), halfHeight, paint);
    paint.color = indicatorColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = indicatorWidth;
    double smallCircleRadius = halfHeight / 2;
    canvas.drawArc(
        new Rect.fromLTRB(smallCircleRadius, smallCircleRadius,
            height - smallCircleRadius, height - smallCircleRadius),
        indicatorStarRadian,
        indicatorRadian,
        false,
        paint);

    double radian = indicatorStarRadian + indicatorRadian;

    Path path = getPath(smallCircleRadius, radian);

    canvas.save();
    canvas.translate(halfHeight, halfHeight);
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  void drawCornerButton(Canvas canvas, Paint paint, double halfHeight,
      String txt, TextStyle txtStyle) {
    canvas.drawCircle(new Offset(halfHeight, halfHeight), halfHeight, paint);

    double rectRight = width - halfHeight;
    canvas.drawRect(
        new Rect.fromLTRB(halfHeight, 0.0, rectRight, height), paint);

    canvas.drawCircle(new Offset(rectRight, halfHeight), halfHeight, paint);

    TextPainter textPainter = new TextPainter();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = new TextSpan(text: txt, style: txtStyle);
    textPainter.layout();
    double textStarPositionX = (width - textPainter.size.width) / 2;
    double textStarPositionY = (height - textPainter.size.height) / 2;
    textPainter.paint(canvas, new Offset(textStarPositionX, textStarPositionY));
  }

  Path getPath(double radius, double radian) {
    Path path = new Path();

    double yPoint = sin(radian) * radius;
    double xPoint = cos(radian) * radius;

    double halfSide = isoscelesTriangle / 2;
    path.moveTo(xPoint, yPoint + halfSide);

    path.lineTo(xPoint, yPoint - halfSide);

    double xVertex =
        xPoint + sqrt(pow(isoscelesTriangle, 2) - pow(halfSide, 2));
    path.lineTo(xVertex, yPoint);

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LoginErrorMessageController {
  AnimatedButtonState loginState;

  void showErrorMessage(String errorMsg) {
    if (loginState != null) {
      loginState.changeErrorMsg(errorMsg);
    }
  }
}
