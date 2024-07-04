import 'package:croppy/src/src.dart';
import 'package:croppy/src/widgets/cupertino/cupertino_image_cropper_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ide_theme/ide_theme.dart';
import 'package:provider/provider.dart';

const kCupertinoImageCropperBackgroundColor = Color(0xFF0A0A0A);

class CupertinoImageCropperPage extends StatelessWidget {
  const CupertinoImageCropperPage({
    super.key,
    required this.controller,
    required this.shouldPopAfterCrop,
    this.gesturePadding = 16.0,
    this.heroTag,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Object? heroTag;
  final bool shouldPopAfterCrop;

  @override
  Widget build(BuildContext context) {
    var ide = Provider.of<IDEThemeNotifier>(context).isDarkMode;
    return CroppableImagePageAnimator(
      controller: controller,
      heroTag: heroTag,
      builder: (context, overlayOpacityAnimation) {
        return CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          navigationBar: CupertinoImageCropperAppBar(
            controller: controller,
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            // minimum: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                Expanded(
                  child: RepaintBoundary(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ide
                            ? const Color(0xFF393B40)
                            : IDEThemeNotifier.of(context)
                                .interTheme
                                .primarySurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      // padding: const EdgeInsets.all(4),
                      child: AnimatedCroppableImageViewport(
                        controller: controller,
                        overlayOpacityAnimation: overlayOpacityAnimation,
                        gesturePadding: gesturePadding,
                        heroTag: heroTag,
                        cropHandlesBuilder: (context) =>
                            CupertinoImageCropHandles(
                          controller: controller,
                          gesturePadding: gesturePadding,
                        ),
                      ),
                    ),
                  ),
                ),
                RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: overlayOpacityAnimation,
                    builder: (context, _) => Opacity(
                      opacity: overlayOpacityAnimation.value,
                      child: Column(
                        children: [
                          CupertinoToolbar(
                            controller: controller,
                          ),
                          CupertinoImageCropperBottomAppBar(
                            controller: controller,
                            shouldPopAfterCrop: shouldPopAfterCrop,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
