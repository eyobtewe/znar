import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:znar/src/core/core.dart';
import 'package:znar/src/presentation/ui_provider.dart';
import '../../core/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UiBloc uiBloc;
  File image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        debugPrint(image.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    uiBloc = UiProvider.of(context);
    return SafeArea(
      child: Scaffold(
        // bottomNavigationBar: BottomNavBar(currentIndex: 3),
        body: DefaultTabController(
          length: contents.length,
          child: CustomScrollView(
            slivers: [
              buildSliverAppbar(),
              SliverFillRemaining(
                child: TabBarView(
                  children: contents
                      .map(
                        (e) => Center(child: Text(e)),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppbar() {
    return SliverAppBar(
      expandedHeight: 250,
      actions: [
        IconButton(
          iconSize: 18,
          onPressed: () {
            showDialog(
                context: context,
                barrierColor: BACKGROUND.withOpacity(0.8),
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: CANVAS_BLACK.withOpacity(0.5),
                    title: image == null
                        ? IconButton(
                            onPressed: () async {
                              await getImage();
                            },
                            icon: Icon(
                              Ionicons.person_circle_outline,
                              color: DARK_GRAY,
                              size: 80,
                            ))
                        : Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                    content: TextField(),
                    actions: [
                      Icon(Ionicons.checkmark),
                      Icon(Ionicons.close),
                    ],
                  );
                });
          },
          icon: Icon(Ionicons.pencil),
        )
      ],
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: CANVAS_BLACK,
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              image == null
                  ? InkWell(
                      onTap: () async {
                        await getImage();
                      },
                      child: Icon(
                        Ionicons.person_circle_outline,
                        color: DARK_GRAY,
                        size: 80,
                      ),
                    )
                  : ClipOval(
                      child: Image.file(
                        image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
              Divider(color: TRANSPARENT),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: size.width,
                    child: Text(
                      'ሀፍቶም ገብረሚካኤል',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamilyFallback: ['Kefa'],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildFollowBtn('followers', 495),
                  buildFollowBtn('following', 22),
                ],
              ),
              Divider(color: TRANSPARENT),
            ],
          ),
        ),
      ),
      bottom: TabBar(
        tabs: contents
            .map(
              (e) => Tab(text: e),
            )
            .toList(),
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  Widget buildFollowBtn(String title, int number) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(CANVAS_BLACK),
        elevation: MaterialStateProperty.all(0),
        // shape: MaterialStateProperty.all(RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(100),
        //     side: BorderSide(
        //       color: BACKGROUND,
        //       width: 1,
        //     )))
      ),
      child: Text(
        '$number ' + Language.locale(uiBloc.language, title),
        style: TextStyle(
          color: PRIMARY_COLOR.withAlpha(200),
          fontFamilyFallback: f,
        ),
      ),
    );
  }
}

List<String> contents = [
  'Recently Played',
  'Most Played',
  'Favorites',
  'Private Playlists',
];
