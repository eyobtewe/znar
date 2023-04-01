// import 'package:flutter/material.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// import '../../core/core.dart';
// import '../../presentation/bloc.dart';
// import 'widgets.dart';

// class DownloadProgress extends StatelessWidget {
//   const DownloadProgress({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final uiBloc = UiProvider.of(context);
//     return StreamBuilder<DownloadStatus>(
//       stream: uiBloc.progressStr,
//       builder: (_, AsyncSnapshot<DownloadStatus> snapshot) {
//         return Visibility(
//           visible: (snapshot.hasData) &&
//               (snapshot.data == DownloadStatus.LOADING || snapshot.data == DownloadStatus.DOWNLOADING),
//           // visible: true,
//           child: InkWell(
//             onTap: null,
//             child: Container(
//               color: cBackgroundColor.withOpacity(0.8),
//               width: size.width,
//               height: size.height,
//               child: Center(
//                 child: Container(
//                   width: size.width * 0.4,
//                   height: size.height * 0.3,
//                   decoration: BoxDecoration(color: cBackgroundColor),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       DownloadStatus.LOADING == snapshot.data ? CustomLoader() : buildCircularProgress(uiBloc),
//                       Divider(color: cTransparent),
//                       Text((snapshot.data != null ? '${uiBloc.downloadProgess} %' : '0%')),
//                       Divider(color: cTransparent),
//                       FlatButton(
//                         color: cCanvasBlack,
//                         onPressed: () {
//                           uiBloc.killDownloader();
//                         },
//                         child: Text('Cancel'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildCircularProgress(UiBloc uiBloc) {
//     return Container(
//       height: 30,
//       width: 30,
//       child: SleekCircularSlider(
//         min: 0,
//         initialValue: uiBloc.downloadProgess.toDouble(),
//         max: 100,
//         appearance: CircularSliderAppearance(
//           size: 0,
//           customWidths: CustomSliderWidths(
//             progressBarWidth: 7,
//             trackWidth: 0,
//           ),
//           startAngle: 120,
//           angleRange: 300,
//         ),
//       ),
//     );
//   }
// }
