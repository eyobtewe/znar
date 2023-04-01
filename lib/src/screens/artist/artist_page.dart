import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/core.dart';

import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../search/search.dart';
import '../widgets/widgets.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({Key key}) : super(key: key);

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  Size size;
  ApiBloc bloc;
  UiBloc uiBloc;

  int page = 1;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(_listener);
  }

  void _listener() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      setState(() {
        page++;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: Stack(
        children: [
          FutureBuilder(
            future: bloc.fetchArtists(page, 30),
            initialData: bloc.artists,
            builder: (_, AsyncSnapshot<List<Artist>> snapshot) {
              if (!snapshot.hasData) {
                return const CustomLoader();
              } else {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    buildBody(bloc.artists),
                    const BottomPlayerSpacer(),
                  ],
                );
              }
            },
          ),
          const ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody(List<Artist> artists) {
    return GridView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
      ),
      itemCount: artists?.length ?? 0,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (_, int i) => ArtistThumbnail(artist: artists[i]),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: cTransparent,
      centerTitle: false,
      leading: IconButton(
          onPressed: () {
            uiBloc.toggleLanguage();
            setState(() {});
          },
          icon: const Icon(Ionicons.language)),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {
              showSearch(context: context, delegate: SongSearch(MEDIA.ARTIST));
            }),
      ],
      // title: Text(
      //   Language.locale(uiBloc.language, 'artists'),
      //   style: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     // fontSize: ScreenUtil().setSp(28),
      //     fontFamilyFallback: f,
      //   ),
      // ),
    );
  }
}
