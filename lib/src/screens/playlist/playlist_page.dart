import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class PlaylistsScreen extends StatefulWidget {
  final bool isHome;

  const PlaylistsScreen({Key key, this.isHome = false}) : super(key: key);
  @override
  _PlaylistsScreenState createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  Size size;
  ApiBloc bloc;
  @override
  void initState() {
    super.initState();
  }

  UiBloc uiBloc;
  @override
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, allowFontScaling: true, designSize: size);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: widget.isHome ? null : BottomScreenPlayer(),
        appBar: widget.isHome ? null : buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  TabBarView buildBody() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FutureBuilder(
          future: bloc.fetchOnlinePlayList(1, 20),
          initialData: bloc.onlinePlaylists,
          builder:
              (BuildContext context, AsyncSnapshot<List<Playlist>> snapshot) {
            if (!snapshot.hasData) {
              return const CustomLoader();
            } else {
              return buildOnlinePlaylist(bloc.onlinePlaylists);
            }
          },
        ),
        FutureBuilder(
          future: bloc.fetchLocalPlaylists(),
          initialData: bloc.localPlaylists,
          builder:
              (BuildContext context, AsyncSnapshot<List<Playlist>> snapshot) {
            if (!snapshot.hasData) {
              return const CustomLoader();
            } else {
              return buildLocalPlaylist(snapshot.data);
            }
          },
        ),
      ],
    );
  }

  Widget buildAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_PLAYLISTS_PAGE_ROUTE);
            }),
      ],
      centerTitle: true,
      title: Text(
        Language.locale(uiBloc.language, 'playlists'),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamilyFallback: f,
        ),
      ),
      bottom: TabBar(
        labelPadding: const EdgeInsets.all(10),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Text(
            Language.locale(uiBloc.language, 'online_playlists'),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(16),
              fontFamilyFallback: f,
            ),
          ),
          Text(
            Language.locale(uiBloc.language, 'local_playlists'),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(16),
              fontFamilyFallback: f,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOnlinePlaylist(List<Playlist> playlists) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
      ),
      itemCount: playlists.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (BuildContext ctx, int i) =>
          PlaylistThumbnail(playlist: playlists[i]),
    );
  }

  Widget buildLocalPlaylist(List<Playlist> playlists) {
    return Scaffold(
      floatingActionButton: widget.isHome
          ? null
          : FloatingActionButton(
              backgroundColor: CANVAS_BLACK,
              child: const Icon(Ionicons.add_circle),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext ctx) => CreatePlaylist(),
                );
                setState(() {});
              },
            ),
      body: ListView.separated(
        separatorBuilder: (BuildContext ctx, int i) => Divider(),
        physics: const BouncingScrollPhysics(),
        itemCount: playlists.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext ctx, int i) =>
            buildDismissible(playlists, i),
      ),
    );
  }

  Dismissible buildDismissible(List<Playlist> playlists, int i) {
    return Dismissible(
      background: Container(
        padding: const EdgeInsets.all(5),
        color: RED.withOpacity(0.25),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete),
      ),
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection d) async {
        await bloc.removePlaylist(playlists[i]);
        Fluttertoast.showToast(
          msg: Language.locale(uiBloc.language, 'playlist_deleted'),
          backgroundColor: PURE_WHITE,
          textColor: BACKGROUND,
        );
        setState(() {});
      },
      child: PlaylistTile(playlist: playlists[i]),
    );
  }
}
