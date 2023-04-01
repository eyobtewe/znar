import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:znar/src/core/core.dart';
import 'package:znar/src/presentation/ui_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UiBloc uiBloc;
  File image;
  // final picker = ImagePicker();

  Future getImage() async {
    dynamic pickedFile;
    // = await picker.getImage(
    //   source: ImageSource.gallery,
    // );

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
                barrierColor: cBackgroundColor.withOpacity(0.8),
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: cCanvasBlack.withOpacity(0.5),
                    title: image == null
                        ? IconButton(
                            onPressed: () async {
                              await getImage();
                            },
                            icon: const Icon(
                              Ionicons.person_circle_outline,
                              color: cDarkGray,
                              size: 80,
                            ))
                        : Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                    content: const TextField(),
                    actions: const [
                      Icon(Ionicons.checkmark),
                      Icon(Ionicons.close),
                    ],
                  );
                });
          },
          icon: const Icon(Ionicons.pencil),
        )
      ],
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: cCanvasBlack,
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              image == null
                  ? InkWell(
                      onTap: () async {
                        await getImage();
                      },
                      child: const Icon(
                        Ionicons.person_circle_outline,
                        color: cDarkGray,
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
              const Divider(color: cTransparent),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: size.width,
                    child: const Text(
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
              const Divider(color: cTransparent),
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
        backgroundColor: MaterialStateProperty.all<Color>(cCanvasBlack),
        elevation: MaterialStateProperty.all(0),
        // shape: MaterialStateProperty.all(RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(100),
        //     side: BorderSide(
        //       color: cBackgroundColor,
        //       width: 1,
        //     )))
      ),
      child: Text(
        '$number ${Language.locale(uiBloc.language, title)}',
        style: TextStyle(
          color: cPrimaryColor.withAlpha(200),
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
