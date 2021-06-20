// import 'package:flutter/material.dart';
// import 'package:flutter_audio_query/flutter_audio_query.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../core/core.dart';
// import '../screens.dart';

// class GenreTile extends StatelessWidget {
//   const GenreTile({
//     this.genre,
//     this.isSearchResult,
//   });

//   final bool isSearchResult;
//   final GenreInfo genre;

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     ScreenUtil.init(context, designSize: size);
//     return Container(
//       // height: 170,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: ListTile(
//         leading: CircleAvatar(
//           child: Text(genre.name.substring(0, 1)),
//         ),
//         title: Text(
//           genre.name,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(fontFamilyFallback: f),
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => GenreDetailScreen(genreTitle: genre.name),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
