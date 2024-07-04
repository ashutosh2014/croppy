import 'package:croppy/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ide_theme/ide_theme.dart';
import 'package:provider/provider.dart';

class CupertinoImageCropperBottomAppBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  const CupertinoImageCropperBottomAppBar({
    super.key,
    required this.controller,
    required this.shouldPopAfterCrop,
  });

  final CroppableImageController controller;
  final bool shouldPopAfterCrop;

  @override
  Widget build(BuildContext context) {
    final l10n = CroppyLocalizations.of(context)!;
    var ide = Provider.of<IDEThemeNotifier>(context).isDarkMode;
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
          color: IDEThemeNotifier.of(context).backgroundColor.color10,
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.all(10),
      height: 56,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.focused)) {
                    final colorC = Color.alphaBlend(
                        const Color(0x0e000000),
                        ide
                            ? const Color(0xFFB8C4FF)
                            : const Color(0xFF3574F0));

                    ///Share Button Colors Below.
                    // ide ?
                    // const Color(0xFFC2C1FF) : const Color(0xFF7D7BF2));
                    return colorC;
                  }
                  if (states.contains(MaterialState.hovered)) {
                    final colorC = Color.alphaBlend(
                        const Color(0x0e000000),

                        ///Share Button Colors Below.
                        // ide ? const Color(0xFFC2C1FF) : const Color(0xFF7D7BF2));
                        ide
                            ? const Color(0xFFB8C4FF)
                            : const Color(0xFF3574F0));
                    return colorC;
                  }
                  return ide
                      ? const Color(0xFFB8C4FF)
                      : const Color(0xFF3574F0);

                  ///Share Button Colors Below.
                  // ide ? const Color(0xFFC2C1FF) : const Color(0xFF7D7BF2);
                }),
                overlayColor:
                    const MaterialStatePropertyAll(Colors.transparent),
              ),
              onPressed: () async {
                CroppableImagePageAnimator.of(context)?.setHeroesEnabled(true);
                controller.crop();
              },
              child: Text(l10n.doneLabel,
                  style: IDEThemeNotifier.of(context)
                      .textStyles
                      .labelMedium
                      .copyWith(
                          color: IDEThemeNotifier.of(context)
                              .textColor
                              .neutral98)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44.0);

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
