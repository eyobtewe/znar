// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';

// import '../../core/core.dart';
// import '../../presentation/bloc.dart';
// import '../screens.dart';

// class LocalScreen extends StatefulWidget {
//   @override
//   _LocalScreenState createState() => _LocalScreenState();
// }

// class _LocalScreenState extends State<LocalScreen> {
//   UiBloc uiBloc;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     uiBloc = UiProvider.of(context);
//     final localSongsBloc = LocalSongsProvider.of(context);
//     localSongsBloc.fetchAll();
//     return Container(
//       child: GridView.count(
//         physics: const BouncingScrollPhysics(),
//         crossAxisCount: 2,
//         children: [
//           buildButtons('assets/images/10.jpg', 0),
//           buildButtons('assets/images/8.jpg', 1),
//           buildButtons('assets/images/7.jpg', 2),
//           buildButtons('assets/images/6.jpg', 3),
//         ],
//       ),
//     );
//   }

//   Widget buildButtons(String path, int title) {
//     IconData icon;
//     switch (title) {
//       case 0:
//         icon = Icons.audiotrack;
//         break;
//       case 1:
//         icon = Ionicons.person;
//         break;
//       case 2:
//         icon = Icons.album;
//         break;
//       case 3:
//         icon = Icons.file_download;
//         break;
//       default:
//     }
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => title == 3
//                 ? DownloadedSongsScreen()
//                 : LocalSongsScreen(categoryTitle: tabs[title]),
//           ),
//         );
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(icon, size: 48),
//           ),
//           Text(
//             Language.locale(uiBloc.language, tabs[title].toLowerCase()),
//             style: TextStyle(
//               fontSize: 18,
//               color: GRAY,
//               fontFamilyFallback: f,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
