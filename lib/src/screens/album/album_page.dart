import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class AlbumScreen extends StatefulWidget {
  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  // final _nativeAdController = NativeAdmobController();
  // double _height = 0;
  int page = 1;
  ScrollController scrollController;

  // StreamSubscription _subscription;

  // void _onStateChanged(AdLoadState state) {
  //   if (state == AdLoadState.loadCompleted) {
  //     setState(() {
  //       _height = 330;
  //     });
  //   }
  // }

  void _listener() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      setState(() {
        page++;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(_listener);
    // _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    // _nativeAdController.setTestDeviceIds(['0285E4EA075685841E958F067765106D']);
  }

  @override
  void dispose() {
    // _subscription.cancel();
    scrollController.removeListener(_listener);
    scrollController.dispose();
    // _nativeAdController.dispose();
    super.dispose();
  }

  Size size;
  ApiBloc bloc;
  UiBloc uiBloc;
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          FutureBuilder(
            future: bloc.fetchAlbums(page, 30),
            initialData: bloc.albums,
            builder:
                (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
              if (!snapshot.hasData) {
                return const CustomLoader();
              } else {
                return buildBody(bloc.albums);
              }
            },
          ),
          ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody(List<Album> albums) {
    // albums.add(Album());
    return Container(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        shrinkWrap: true,
        children: <Widget>[
          buildNewAlbums(albums),

          // Container(
          //   child: StaggeredGridView.countBuilder(
          //     shrinkWrap: true,
          //     primary: false,
          //     staggeredTileBuilder: (int i) {
          //       return (i % 6 == 0 && i != 0) ? StaggeredTile.extent(3, _height) : StaggeredTile.extent(1, 170);
          //     },
          //     crossAxisCount: 3,
          //     itemCount: albums.length ?? 0,
          //     itemBuilder: (BuildContext ctx, int i) => (i % 6 == 0 && i != 0)
          //         ? BuildAd(height: _height, nativeAdController: _nativeAdController)
          //         : AlbumThumbnail(album: albums[i]),
          //   ),
          // ),
          GridView.builder(
            primary: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
            ),
            itemCount: albums?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (BuildContext ctx, int i) =>
                AlbumThumbnail(album: albums[i]),
          ),
          // BuildAd(height: _height, nativeAdController: _nativeAdController)
        ],
      ),
    );
  }

  Widget buildNewAlbums(List<Album> albums) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25, top: 5, left: 10, right: 10),
      height: size.width * 9 / 16,
      child: Swiper(
        itemCount: albums.length < 3 ? albums.length : 3,
        autoplayDelay: 10000,
        viewportFraction: 0.55,
        scale: 0.6,
        autoplay: true,
        autoplayDisableOnInteraction: false,
        itemBuilder: (BuildContext context, int index) => ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext ctx) => AlbumDetailScreen(
                      album: albums[index],
                    ),
                  ),
                );
              },
              child: CachedPicture(image: albums[index].albumArt)),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      // elevation: 0,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ALBUMS_PAGE_ROUTE);
            }),
      ],
      title: Text(
        Language.locale(uiBloc.language, 'albums'),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamilyFallback: f,
        ),
      ),
    );
  }
}
