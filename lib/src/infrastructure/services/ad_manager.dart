// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_native_admob/flutter_native_admob.dart';
// import 'package:flutter_native_admob/native_admob_controller.dart';
// import 'package:flutter_native_admob/native_admob_options.dart';
// import 'package:musica/src/core/core.dart';

// class AdManager {
//   static String get appId {
//     if (Platform.isAndroid) {
//       // return "ca-app-pub-3940256099942544~4354546703";
//       return "ca-app-pub-3940256099942544/2247696110";
//       // return "ca-app-pub-3023996001087093~9440864491";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544~2594085930";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/8865242552";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/4339318960";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/7049598008";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/3964253750";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/8673189370";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/7552160883";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
// }
// // import 'dart:io';

// // class AdManager {
// //   static String get appId {
// //     if (Platform.isAndroid) {
// //       return "<YOUR_ANDROID_ADMOB_APP_ID>";
// //     } else if (Platform.isIOS) {
// //       return "<YOUR_IOS_ADMOB_APP_ID>";
// //     } else {
// //       throw new UnsupportedError("Unsupported platform");
// //     }
// //   }

// //   static String get bannerAdUnitId {
// //     if (Platform.isAndroid) {
// //       return "<YOUR_ANDROID_BANNER_AD_UNIT_ID";
// //     } else if (Platform.isIOS) {
// //       return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
// //     } else {
// //       throw new UnsupportedError("Unsupported platform");
// //     }
// //   }

// //   static String get interstitialAdUnitId {
// //     if (Platform.isAndroid) {
// //       return "<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>";
// //     } else if (Platform.isIOS) {
// //       return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
// //     } else {
// //       throw new UnsupportedError("Unsupported platform");
// //     }
// //   }

// //   static String get rewardedAdUnitId {
// //     if (Platform.isAndroid) {
// //       return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
// //     } else if (Platform.isIOS) {
// //       return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
// //     } else {
// //       throw new UnsupportedError("Unsupported platform");
// //     }
// //   }
// // }

// class BuildAd extends StatelessWidget {
//   const BuildAd({
//     @required this.height,
//     @required this.nativeAdController,
//   });

//   final double height;
//   final NativeAdmobController nativeAdController;

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Container(
//       height: height,
//       width: size.width,
//       padding: const EdgeInsets.all(10),
//       child: NativeAdmob(
//         numberAds: 3,
//         error: Container(),
//         adUnitID: AdManager.appId,
//         controller: nativeAdController,
//         options: NativeAdmobOptions(
//           ratingColor: BLUE,
//           storeTextStyle: NativeTextStyle(backgroundColor: BLUE, color: PURE_WHITE),
//           adLabelTextStyle: NativeTextStyle(backgroundColor: BLUE),
//           callToActionStyle: NativeTextStyle(backgroundColor: BLUE),
//           bodyTextStyle: NativeTextStyle(backgroundColor: BLUE, color: PURE_WHITE),
//           headlineTextStyle: NativeTextStyle(backgroundColor: BLUE, color: PURE_WHITE),
//           advertiserTextStyle: NativeTextStyle(backgroundColor: BLUE, color: PURE_WHITE),
//           priceTextStyle: NativeTextStyle(backgroundColor: BLUE, color: PURE_WHITE),
//         ),
//         loading: Container(),
//       ),
//     );
//   }
// }
