import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kalm/color/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

Widget IMAGE_CACHE(
  String url, {
  double? height,
  double? width,
  BoxFit? fit,
  double circularRadius = 15,
  Widget? widgetInsideImage,
  void Function()? onTapImage,
  String? costumImageAssetError,
  double? costumImageAssetErrorScale,
}) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(circularRadius),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: onTapImage,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: fit ?? BoxFit.fill,
              height: height ?? Get.height / 4,
              width: width ?? Get.width,
              errorWidget: (context, s, d) {
                print(s);
                if (costumImageAssetError == null) {
                  return Image.asset(
                    costumImageAssetError ?? "assets/image/no_images.png",
                    height: height ?? Get.height / 4,
                    width: width ?? Get.width,
                    fit: BoxFit.fill,
                  );
                } else {
                  return CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Image.asset(
                      costumImageAssetError,
                      scale: costumImageAssetErrorScale ?? 2,
                      color: BLUEKALM,
                    ),
                  );
                }
              },
              placeholder: (context, s) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.3, color: BLUEKALM)),
                  height: height ?? Get.height / 4,
                  width: width ?? Get.width,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: BLUEKALM,
                      child: const Card()),
                );
              },
            ),
          ),
          if (widgetInsideImage != null) widgetInsideImage
        ],
      ));
}
