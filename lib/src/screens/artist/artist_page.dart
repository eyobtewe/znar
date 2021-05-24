import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../home/explore.dart';
import '../search/search.dart';
import '../widgets/widgets.dart';

class ArtistScreen extends StatefulWidget {
  @override
  _ArtistScreenState createState() => _ArtistScreenState();
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
      appBar: buildAppBar(),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 66),
            child: FutureBuilder(
              future: bloc.fetchArtists(page, 30),
              initialData: bloc.artists,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Artist>> snapshot) {
                if (!snapshot.hasData) {
                  return const CustomLoader();
                } else {
                  return buildBody(bloc.artists);
                }
              },
            ),
          ),
          ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody(List<Artist> artists) {
    return GridView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: artists?.length ?? 0,
      // shrinkWrap: true,
      itemBuilder: (BuildContext ctx, int i) =>
          ArtistThumbnail(artist: artists[i]),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      // elevation: 0,
      centerTitle: false,
      actions: <Widget>[
        IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SongSearch(CustomAspectRatio.ARTIST));
            }),
      ],
      title: Text(
        Language.locale(uiBloc.language, 'artists'),
        style: TextStyle(
          fontWeight: FontWeight.w800,
          // fontSize: ScreenUtil().setSp(28),
          fontFamilyFallback: f,
        ),
      ),
    );
  }
}
