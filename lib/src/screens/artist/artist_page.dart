import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
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
      bottomNavigationBar: BottomScreenPlayer(),
      body: FutureBuilder(
        future: bloc.fetchArtists(page, 30),
        initialData: bloc.artists,
        builder: (BuildContext context, AsyncSnapshot<List<Artist>> snapshot) {
          if (!snapshot.hasData) {
            return const CustomLoader();
          } else {
            return buildBody(bloc.artists);
          }
        },
      ),
    );
  }

  Widget buildBody(List<Artist> artists) {
    return Container(
      child: GridView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: artists?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (BuildContext ctx, int i) =>
            ArtistThumbnail(artist: artists[i]),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      // elevation: 0,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ARTISTS_PAGE_ROUTE);
            }),
      ],
      title: Text(
        Language.locale(uiBloc.language, 'artists'),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamilyFallback: f,
        ),
      ),
    );
  }
}
