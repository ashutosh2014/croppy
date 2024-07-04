import 'dart:math';

import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ide_theme/ide_theme.dart';

class CupertinoImageTransformationToolbar extends StatefulWidget {
  const CupertinoImageTransformationToolbar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  @override
  State<CupertinoImageTransformationToolbar> createState() =>
      _CupertinoImageTransformationToolbarState();
}

enum _Knob {
  rotateZ,
  rotateY,
  rotateX,
}

class _CupertinoImageTransformationToolbarState
    extends State<CupertinoImageTransformationToolbar> {
  late _Knob? _activeKnob;
  late final List<_Knob> _knobs;

  @override
  void initState() {
    super.initState();

    _knobs = [
      if (widget.controller.isTransformationEnabled(Transformation.rotateZ))
        _Knob.rotateZ,
      if (widget.controller.isTransformationEnabled(Transformation.rotateX))
        _Knob.rotateX,
      if (widget.controller.isTransformationEnabled(Transformation.rotateY))
        _Knob.rotateY,
    ];

    _activeKnob = _knobs.isNotEmpty ? _knobs.first : null;
  }

  Widget _buildRotationSlider(BuildContext context) {
    if (_activeKnob == _Knob.rotateZ) {
      return ValueListenableBuilder(
        key: const Key('rotateZ'),
        valueListenable: widget.controller.rotationZNotifier,
        builder: (context, rotationZ, _) => CupertinoRotationSlider(
          value: rotationZ,
          extent: pi / 4,
          onStart: widget.controller.onStraightenStart,
          onEnd: widget.controller.onStraightenEnd,
          onChanged: (v) {
            widget.controller.onStraighten(angleRad: v);
          },
        ),
      );
    }

    if (_activeKnob == _Knob.rotateX) {
      return ValueListenableBuilder(
        key: const Key('rotateX'),
        valueListenable: widget.controller.rotationXNotifier,
        builder: (context, rotationX, _) => CupertinoRotationSlider(
          value: rotationX,
          extent: pi / 6,
          isReversed: true,
          onStart: widget.controller.onRotateXStart,
          onEnd: widget.controller.onRotateXEnd,
          onChanged: (v) {
            widget.controller.onRotateX(angleRad: v);
          },
        ),
      );
    }

    if (_activeKnob == _Knob.rotateY) {
      return ValueListenableBuilder(
        key: const Key('rotateY'),
        valueListenable: widget.controller.rotationYNotifier,
        builder: (context, rotationY, _) => CupertinoRotationSlider(
          value: rotationY,
          extent: pi / 6,
          onStart: widget.controller.onRotateYStart,
          onEnd: widget.controller.onRotateYEnd,
          onChanged: (v) {
            widget.controller.onRotateY(angleRad: v);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  List<Widget> _buildKnobs(BuildContext context) {
    return [
      if (widget.controller.isTransformationEnabled(Transformation.rotateZ))
        _CupertinoRotationKnobWidget(
          key: const Key('rotateZ'),
          notifier: widget.controller.rotationZNotifier,
          extent: 45.0,
          isActive: _activeKnob == _Knob.rotateZ,
          onSelected: () => setState(() => _activeKnob = _Knob.rotateZ),
          onChanged: (v) => widget.controller.onStraighten(angleRad: v),
          inactiveChild: CupertinoStraightenIcon(
            color: _activeKnob != _Knob.rotateZ
                ? IDEThemeNotifier.of(context).textColor.neutral40
                : IDEThemeNotifier.of(context).textColor.neutral100,
          ),
        ),
      if (widget.controller.isTransformationEnabled(Transformation.rotateX))
        _CupertinoRotationKnobWidget(
          key: const Key('rotateX'),
          notifier: widget.controller.rotationXNotifier,
          extent: 30.0,
          isReversed: true,
          isActive: _activeKnob == _Knob.rotateX,
          onSelected: () => setState(() => _activeKnob = _Knob.rotateX),
          onChanged: (v) => widget.controller.onRotateX(angleRad: v),
          inactiveChild: CupertinoPerspectiveXIcon(
            color: _activeKnob != _Knob.rotateX
                ? IDEThemeNotifier.of(context).textColor.neutral40
                : IDEThemeNotifier.of(context).textColor.neutral100,
          ),
        ),
      if (widget.controller.isTransformationEnabled(Transformation.rotateY))
        _CupertinoRotationKnobWidget(
          key: const Key('rotateY'),
          notifier: widget.controller.rotationYNotifier,
          extent: 30.0,
          isActive: _activeKnob == _Knob.rotateY,
          onSelected: () => setState(() => _activeKnob = _Knob.rotateY),
          onChanged: (v) => widget.controller.onRotateY(angleRad: v),
          inactiveChild: CupertinoPerspectiveYIcon(
            color: _activeKnob != _Knob.rotateY
                ? IDEThemeNotifier.of(context).textColor.neutral40
                : IDEThemeNotifier.of(context).textColor.neutral100,
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_activeKnob == null) {
      return const SizedBox.expand();
    }
    return Container(
      decoration: BoxDecoration(
        color: IDEThemeNotifier.of(context).backgroundColor.color10,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 146,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.string(
                '''<svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_1431_364)">
<path d="M12.5411 9.92915H8.70277C8.84277 7.29165 7.70333 5.95832 6.84 5.33749L8.45389 3.41249C8.70666 3.11249 8.68333 2.65415 8.40333 2.38332C8.12333 2.11249 7.69166 2.13749 7.44277 2.43749L0.952219 10.1708C0.77333 10.3833 0.726664 10.6917 0.835552 10.9542C0.944441 11.2167 1.18944 11.3875 1.45777 11.3875H12.5411C12.9183 11.3875 13.2217 11.0625 13.2217 10.6583C13.2217 10.2542 12.9183 9.92915 12.5411 9.92915V9.92915ZM5.92611 6.42499C6.48222 6.76249 7.47778 7.68332 7.33778 9.92915H2.98611L5.92611 6.42499Z" fill="#6E6E73"/>
</g>
<defs>
<clipPath id="clip0_1431_364">
<rect width="12.4444" height="13.3333" fill="white" transform="translate(0.777344 0.333984)"/>
</clipPath>
</defs>
</svg>
''',
                color: IDEThemeNotifier.of(context).textColor.neutral40,
                height: 16,
                width: 16,
              ),
              const SizedBox.square(
                dimension: 4,
              ),
              Text(
                'Rotation',
                style: IDEThemeNotifier.of(context)
                    .textStyles
                    .labelMedium
                    .copyWith(
                        fontSize: 14,
                        color:
                            IDEThemeNotifier.of(context).textColor.neutral40),
              )
            ],
          ),
          const SizedBox.square(
            dimension: 6,
          ),
          _CupertinoImageTransformationToolbarKnobs(
            activeKnob: _activeKnob!,
            knobs: _knobs,
            children: _buildKnobs(context),
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
                color: IDEThemeNotifier.of(context).backgroundColor.color,
                borderRadius: BorderRadius.circular(8.0)),
            height: 58,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: _buildRotationSlider(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _CupertinoImageTransformationToolbarKnobs extends StatefulWidget {
  const _CupertinoImageTransformationToolbarKnobs({
    required this.activeKnob,
    required this.knobs,
    required this.children,
  });

  final _Knob activeKnob;
  final List<_Knob> knobs;
  final List<Widget> children;

  int get activeKnobIndex => knobs.indexOf(activeKnob);

  @override
  State<_CupertinoImageTransformationToolbarKnobs> createState() =>
      _CupertinoImageTransformationToolbarKnobsState();
}

class _CupertinoImageTransformationToolbarKnobsState
    extends State<_CupertinoImageTransformationToolbarKnobs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  late var _tween = Tween(
    begin: widget.activeKnobIndex.toDouble(),
    end: widget.activeKnobIndex.toDouble(),
  );

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_CupertinoImageTransformationToolbarKnobs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeKnob != widget.activeKnob) {
      _animationController.reset();

      _tween = Tween(
        begin: oldWidget.activeKnobIndex.toDouble(),
        end: widget.activeKnobIndex.toDouble(),
      );

      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    const itemExtent = 64.0;
    final width = widget.children.length * itemExtent;

    final offset = Offset(
      (width - itemExtent) / 2.0 - _tween.evaluate(_animation) * itemExtent,
      0.0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: widget.children.map((v) => v).toList(),
    );
  }
}

class _CupertinoRotationKnobWidget extends StatelessWidget {
  const _CupertinoRotationKnobWidget({
    super.key,
    required this.extent,
    required this.notifier,
    required this.isActive,
    required this.onSelected,
    required this.onChanged,
    required this.inactiveChild,
    this.isReversed = false,
  });

  final double extent;
  final ValueListenable notifier;
  final bool isActive;
  final bool isReversed;
  final VoidCallback onSelected;
  final ValueChanged<double> onChanged;
  final Widget inactiveChild;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, v, _) {
        print(
            "_CupertinoRotationKnobWidget>>> ${isActive} ${(isReversed ? -1 : 1) * v * 180 / pi}");
        return CupertinoKnob(
          isActive: isActive,
          value: (isReversed ? -1 : 1) * v * 180 / pi,
          extent: extent,
          onChanged: (v) {
            print("DSA>> $v $isActive");
            if (!isActive) {
              onSelected();
              return;
            }

            onChanged(v);
          },
          inactiveChild: inactiveChild,
        );
      },
    );
  }
}
