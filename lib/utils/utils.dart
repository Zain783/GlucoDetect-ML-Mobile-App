import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glucoma_app_fyp/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  static void showSnakBar(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: const TextStyle(color: GlobalColors.appColor),
      ),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.blueGrey[50],
    ));
  }

  static void errorSnakbar(context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.red,
    ));
  }

  static cachedImage(String image, int width, int height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        filterQuality: FilterQuality.medium,
        memCacheWidth: 500, // Increase this value for higher quality
        imageUrl: image,
        // width: width,
        height: height.toDouble(),
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return const Icon(
            Icons.error,
            color: Colors.red,
          );
        },
      ),
    );
  }

  static cachedImageWithAnimatedLoading(String image, int width, int height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
              color: GlobalColors.appColor, size: 20),
        ),
        filterQuality: FilterQuality.medium,
        memCacheWidth: 500, // Increase this value for higher quality
        imageUrl: image,
        // width: width,
        height: height.toDouble(),
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return const Icon(
            Icons.error,
            color: Colors.red,
          );
        },
      ),
    );
  }

  static cachedCircularImageWithAnimatedLoading(String image, double size) {
    return ClipOval(
      child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
              color: GlobalColors.appColor, size: 20),
        ),
        filterQuality: FilterQuality.medium,
        memCacheWidth: 500, // Increase this value for higher quality
        imageUrl: image,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return const Icon(
            Icons.error,
            color: Colors.red,
          );
        },
      ),
    );
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 365) {
      return '${difference.inDays} days ago';
    } else {
      final years = difference.inDays ~/ 365;
      return '$years years ago';
    }
  }
}
