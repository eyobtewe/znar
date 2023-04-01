import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';

class CachedPicture extends StatelessWidget {
  const CachedPicture({
    Key key,
    this.image,
    this.boxFit,
    this.isBackground = false,
  }) : super(key: key);

  final String image;
  final BoxFit boxFit;
  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: boxFit ?? BoxFit.cover,
      imageBuilder: (_, ImageProvider<dynamic> imageProvider) {
        return Container(
          decoration: !isBackground
              ? null
              : BoxDecoration(
                  color: cGray.withOpacity(0.5),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
          child: isBackground ? Container() : Image(image: imageProvider),
        );
      },
      errorWidget: (BuildContext context, String url, dynamic error) {
        return buildErrorWidget();
      },
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
        return buildErrorWidget();
      },
    );
  }
}

Widget buildErrorWidget() {
  return Opacity(
    opacity: 0.4,
    child: Container(
      width: 95,
      height: 95,
      decoration: const BoxDecoration(
        color: cCanvasBlack,
        image: DecorationImage(
          image: AssetImage('assets/images/znar_transparent.png'),
        ),
      ),
    ),
  );
}
