import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:ide_theme/ide_theme.dart';

class CupertinoRotationSlider extends StatefulWidget {
  const CupertinoRotationSlider({
    super.key,
    required this.value,
    required this.extent,
    required this.onChanged,
    required this.onStart,
    required this.onEnd,
    this.isReversed = false,
  });

  final double value;
  final double extent;
  final VoidCallback onStart;
  final ValueChanged<double> onChanged;
  final VoidCallback onEnd;
  final bool isReversed;

  @override
  State<CupertinoRotationSlider> createState() =>
      _CupertinoRotationSliderState();
}

class _CupertinoRotationSliderState extends State<CupertinoRotationSlider> {
  double _width = 0.0;
  DragStartDetails? _dragStartDetails;
  double? _dragStartValue;

  void _onPanStart(DragStartDetails details) {
    _dragStartDetails = details;
    _dragStartValue = widget.value;
    widget.onStart();

    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition - _dragStartDetails!.globalPosition;

    var dx = delta.dx;

    if (!widget.isReversed) {
      dx = -dx;
    }

    var value = _dragStartValue! + (dx / _width) * (widget.extent * 2);
    value = value.clamp(-widget.extent, widget.extent);

    widget.onChanged(value);
  }

  void _onPanEnd(DragEndDetails details) {
    _dragStartDetails = null;
    _dragStartValue = null;
    widget.onEnd();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var value = widget.value / widget.extent;

    if (widget.isReversed) {
      value = -value;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: ClipRect(
            child: SizedBox(
              height: 28.0,
              child: Align(
                alignment: Alignment.center,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    _width = constraints.maxWidth;
                    return SizedBox(
                      width: _width,
                      height: 16.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                          opacity: value.abs() > epsilon ? 1.0 : 0.5,
                          child: CustomPaint(
                            painter: _CupertinoSliderPainter(
                              primaryColor: IDEThemeNotifier.of(context)
                                  .textColor
                                  .neutral20,
                              primaryColor2: IDEThemeNotifier.of(context)
                                  .textColor
                                  .neutral30,
                              primaryColor3: IDEThemeNotifier.of(context)
                                  .textColor
                                  .neutral40,
                              primaryColorMain: IDEThemeNotifier.of(context)
                                  .textColor
                                  .neutral10,
                              value: value,
                              isDragging: _dragStartDetails != null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox.square(
          dimension: 6,
        ),
        Text(
          (value * 45).toStringAsFixed(2),
          style: IDEThemeNotifier.of(context).textStyles.labelMedium.copyWith(
              color: IDEThemeNotifier.of(context).textColor.neutral40),
        )
      ],
    );
  }
}

class _CupertinoSliderPainter extends CustomPainter {
  _CupertinoSliderPainter({
    required this.primaryColor,
    required this.primaryColor2,
    required this.primaryColor3,
    required this.primaryColorMain,
    required this.value,
    this.isDragging = false,
  });

  final Color primaryColor, primaryColor2, primaryColor3, primaryColorMain;
  final double value;
  final bool isDragging;

  @override
  void paint(Canvas canvas, Size size) {
    final dividerPaint = Paint()
      ..color = primaryColor2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    final highlightedDividerPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final outOfBoundsDividerPaint = Paint()
      ..color = primaryColor3
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    final center = size.center(Offset(-size.width / 2, 0.0) * value);

    for (var i = -20; i <= 20; i++) {
      final isHighlighted = i % 10 == 0;
      final x = i * (size.width / 20) / 2;
      var _paint = isHighlighted ? highlightedDividerPaint : dividerPaint;

      if (i > 20) {
        _paint = outOfBoundsDividerPaint;
      }

      final absoluteX = center.dx + x;
      final centerDiff = ((size.width / 2) - absoluteX).abs();

      var opacity = 1.0 - (centerDiff.abs() / (size.width / 2)).clamp(0, 1);
      opacity = sqrt(opacity);

      final paint = Paint()
        ..color = _paint.color.withOpacity(_paint.color.opacity * opacity)
        ..style = _paint.style
        ..strokeWidth = _paint.strokeWidth;

      canvas.drawLine(
        Offset(center.dx + x, 2),
        Offset(center.dx + x, size.height),
        paint,
      );
    }

    // canvas.drawCircle(
    //   Offset(center.dx, -8.0),
    //   3.0,
    //   Paint()..color = primaryColor,
    // );

    final tickerPaint = Paint()
      ..color = isDragging ? primaryColor : primaryColorMain
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(size.center(Offset.zero).dx, -8),
      Offset(size.center(Offset.zero).dx, size.height),
      tickerPaint,
    );
  }

  @override
  bool shouldRepaint(_CupertinoSliderPainter oldDelegate) =>
      primaryColor != oldDelegate.primaryColor ||
      value != oldDelegate.value ||
      isDragging != oldDelegate.isDragging;
}
