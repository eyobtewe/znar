import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/core.dart';

class CachedPicture extends StatelessWidget {
  const CachedPicture({this.image, this.boxFit, this.isBackground = false});

  final String image;
  final BoxFit boxFit;
  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$image',
      fit: boxFit ?? BoxFit.cover,
      imageBuilder: (BuildContext ctx, ImageProvider<dynamic> imageProvider) {
        return Container(
          child: isBackground ? Container() : Image(image: imageProvider),
          decoration: !isBackground
              ? null
              : BoxDecoration(
                  color: GRAY.withOpacity(0.5),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
        );
      },
      // progressIndicatorBuilder: (BuildContext ctx, String imageUrl, progress) {
      //   return buildContainer(true);
      // },
      // placeholder: (BuildContext ctx, String imageUrl) {
      //   return buildContainer(true);
      // },
      errorWidget: (BuildContext context, String url, dynamic error) {
        return Opacity(
          opacity: 0.03,
          child: SvgPicture.asset(
            'assets/images/grey-iaam.svg',
            fit: BoxFit.contain,
            width: 150,
          ),
        );
      },
    );
  }

  Container buildContainer(bool b) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 130,
        maxHeight: 130,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          colorFilter:
              ColorFilter.mode(b ? CANVAS_BLACK : BACKGROUND, BlendMode.darken),
          image: AssetImage('assets/images/temp_logo.png'),
        ),
        // color: BACKGROUND,
      ),
    );
  }
}

class CustomFileImage extends StatelessWidget {
  const CustomFileImage(
      {Key key, @required this.img, this.isBackground = false})
      : super(key: key);

  final String img;
  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(img ?? ''),
      fit: BoxFit.cover,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
        return Opacity(
          opacity: 0.5,
          child: SvgPicture.asset(
            'assets/images/grey-iaam.svg',
            fit: BoxFit.contain,
            width: 150,
          ),
        );
      },
    );
  }
}
