import 'package:croppy/src/src.dart';
import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ide_theme/ide_theme.dart';
import 'package:provider/provider.dart';

class CupertinoImageCropperAppBar extends StatefulWidget
    implements ObstructingPreferredSizeWidget {
  CupertinoImageCropperAppBar({
    super.key,
    required this.controller,
  });

  final CroppableImageController controller;

  @override
  State<StatefulWidget> createState() => _CupertinoImageCropperAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}

class _CupertinoImageCropperAppBar extends State<CupertinoImageCropperAppBar> {
  final dropdownKey = GlobalKey<DropdownButtonState>();
  String selectedValue = 'Auto';

  Widget _buildAppBarButtons(BuildContext context) {
    var ide = Provider.of<IDEThemeNotifier>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
          color: IDEThemeNotifier.of(context).backgroundColor.color10,
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.all(10),
      height: 56,
      child: Row(
        children: [
          if (widget.controller.isTransformationEnabled(Transformation.mirror))
            SizedBox(
              height: 36,
              width: 50,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    return ide ? const Color(0xFF43454A) : Colors.white;
                  }),
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                ),
                onPressed: widget.controller.onMirrorHorizontal,
                child: Center(
                  child: CupertinoFlipHorizontalIcon(
                    color: IDEThemeNotifier.of(context).textColor.neutral30,
                    size: 16.0,
                  ),
                ),
              ),
            ),
          if (widget.controller.isTransformationEnabled(Transformation.rotate))
            const SizedBox.square(
              dimension: 10,
            ),
          if (widget.controller.isTransformationEnabled(Transformation.rotate))
            SizedBox(
              height: 36,
              width: 50,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    return ide ? const Color(0xFF43454A) : Colors.white;
                  }),
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                ),
                onPressed: widget.controller.onRotateCCW,
                child: Center(
                  child: Icon(
                    CupertinoIcons.rotate_left_fill,
                    color: IDEThemeNotifier.of(context).textColor.neutral30,
                    size: 16,
                  ),
                ),
              ),
            ),
          if (widget.controller.isTransformationEnabled(Transformation.rotate))
            const SizedBox.square(
              dimension: 10,
            ),
          Center(
            child: ValueListenableBuilder(
              valueListenable: widget.controller.canResetNotifier,
              builder: (context, canReset, child) => SizedBox(
                height: 36,
                width: 50,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return ide ? const Color(0xFF43454A) : Colors.white;
                    }),
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                  ),
                  onPressed: widget.controller.reset,
                  child: Text('Reset',
                      style: IDEThemeNotifier.of(context)
                          .textStyles
                          .labelMedium
                          .copyWith(
                              color: IDEThemeNotifier.of(context)
                                  .textColor
                                  .neutral40)),
                ),
              ),
            ),
          ),
          const Spacer(),
          if (widget.controller is CupertinoCroppableImageController &&
              (widget.controller as CupertinoCroppableImageController)
                      .allowedAspectRatios
                      .length >
                  1)
            ValueListenableBuilder(
              valueListenable:
                  (widget.controller as CupertinoCroppableImageController)
                      .toolbarNotifier,
              builder: (context, toolbar, _) => SizedBox(
                width: 84,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        return IDEThemeNotifier.of(context)
                            .propertyEditorTheme
                            .itemBGColor;
                      }),
                      shape: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return RoundedRectangleBorder(
                            side: IDEThemeNotifier.of(context)
                                .interTheme
                                .primaryBorder,
                            borderRadius: BorderRadius.circular(7),
                          );
                        }

                        if (states.contains(MaterialState.hovered)) {
                          return RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1.0, color: Color(0x4D767680)),
                            borderRadius: BorderRadius.circular(7),
                          );
                        }
                        if (states.contains(MaterialState.pressed)) {
                          return RoundedRectangleBorder(
                            side: IDEThemeNotifier.of(context)
                                .interTheme
                                .primaryBorder,
                            borderRadius: BorderRadius.circular(7),
                          );
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        );
                      }),
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.transparent)),
                  onPressed: () {
                    dropdownKey.currentState?.handleTap();
                  },
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.white,
                      highlightColor: const Color(0x08000000),
                      focusColor: Colors.white,
                    ),
                    child: CustomDropdownButton<String>(
                      bgColor:
                          IDEThemeNotifier.of(context).backgroundColor.color100,
                      key: dropdownKey,
                      itemHoverColor: ide
                          ? const Color(0x1A767680)
                          : const Color(0xFFEBECF0),
                      focusNode: FocusNode(
                          skipTraversal: true, canRequestFocus: false),
                      borderRadius: BorderRadius.circular(8.0),
                      underline: const SizedBox(),
                      isExpanded: true,
                      icon: Icon(
                        Icons.expand_more_rounded,
                        size: 16,
                        color: IDEThemeNotifier.of(context).textColor.neutral30,
                      ),
                      hint: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            selectedValue,
                            style: IDEThemeNotifier.of(context)
                                .textStyles
                                .labelMedium
                                .copyWith(
                                    color: IDEThemeNotifier.of(context)
                                        .textColor
                                        .neutral30),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                        ],
                      ),
                      items: getlst(),
                      onChanged: (selectedValue) {
                        setState(() {
                          this.selectedValue = selectedValue;
                        });
                        switch (selectedValue) {
                          case 'Auto':
                            (widget.controller as AspectRatioMixin)
                                ?.currentAspectRatio = null;
                            break;
                          case 'Square':
                            if (widget.controller is AspectRatioMixin) {
                              (widget.controller as AspectRatioMixin)
                                      ?.currentAspectRatio =
                                  CropAspectRatio(width: 1, height: 1);
                            }
                            break;
                          case 'Original':
                            var imageSize = widget.controller.data.imageSize;
                            (widget.controller as AspectRatioMixin)
                                    ?.currentAspectRatio =
                                CropAspectRatio(
                                    width: imageSize.width.round(),
                                    height: imageSize.height.round());
                            break;
                          default:
                            var aspectRatio = _basicAspectRatios
                                .where((e) =>
                                    selectedValue ==
                                    _convertAspectRatioToString(context, e))
                                .firstOrNull;
                            if (widget.controller is AspectRatioMixin) {
                              (widget.controller as AspectRatioMixin)
                                  ?.currentAspectRatio = aspectRatio;
                            }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  CustomDropdownMenuItem<String> getChildWidget(String value) {
    return CustomDropdownMenuItem<String>(
      value: value,
      child: SizedBox(
        height: 32,
        width: double.infinity,
        child: Row(
          // alignment: Alignment.centerLeft,
          children: [
            const SizedBox.square(
              dimension: 6.0,
            ),
            Text(value,
                style: IDEThemeNotifier.of(context)
                    .textStyles
                    .labelMedium
                    .copyWith(
                      color: IDEThemeNotifier.of(context).textColor.neutral30,
                    )),
          ],
        ),
      ),
    );
  }

  String _convertAspectRatioToString(
    BuildContext context,
    CropAspectRatio? aspectRatio,
  ) {
    final l10n = CroppyLocalizations.of(context)!;

    if (aspectRatio == null) {
      return l10n.cupertinoFreeformAspectRatioLabel;
    }

    final width = aspectRatio.width;
    final height = aspectRatio.height;

    final imageSize = widget.controller.data.imageSize;

    if ((width == imageSize.width && height == imageSize.height) ||
        (width == imageSize.height && height == imageSize.width)) {
      return l10n.cupertinoOriginalAspectRatioLabel;
    }

    if (aspectRatio.isSquare) {
      return l10n.cupertinoSquareAspectRatioLabel;
    }

    return l10n.getAspectRatioLabel(width, height);
  }

  List<CustomDropdownMenuItem<String>> getlst() {
    var lst =
        ['Auto', 'Square', 'Original'].map((e) => getChildWidget(e)).toList();

    lst.addAll(_basicAspectRatios
        .map((e) => getChildWidget(_convertAspectRatioToString(context, e)))
        .toList());

    return lst;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = CroppyLocalizations.of(context)!;
    var ide = Provider.of<IDEThemeNotifier>(context).isDarkMode;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        top: true,
        child: SizedBox(
          // height: preferredSize.height,
          child: Stack(
            children: [
              _buildAppBarButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}

const _basicAspectRatios = [
  // CropAspectRatio(width: 1, height: 1),
  CropAspectRatio(width: 16, height: 9),
  CropAspectRatio(width: 9, height: 16),
  CropAspectRatio(width: 5, height: 4),
  CropAspectRatio(width: 4, height: 5),
  CropAspectRatio(width: 7, height: 5),
  CropAspectRatio(width: 5, height: 7),
  CropAspectRatio(width: 4, height: 3),
  CropAspectRatio(width: 3, height: 4),
  CropAspectRatio(width: 5, height: 3),
  CropAspectRatio(width: 3, height: 5),
  CropAspectRatio(width: 3, height: 2),
  CropAspectRatio(width: 2, height: 3),
];
