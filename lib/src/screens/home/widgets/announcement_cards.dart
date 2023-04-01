import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../../core/core.dart';
import '../../../domain/models/models.dart';
import '../../../helpers/network_image.dart';
import '../../../presentation/bloc.dart';
import '../../screens.dart';

class AnnouncementCards extends StatelessWidget {
   const AnnouncementCards({Key key, this.size}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    final bloc = ApiProvider.of(context);
    return FutureBuilder(
      future: bloc.fetchAnnouncements(),
      initialData: bloc.announcement,
      builder: (_, AsyncSnapshot<List<Announcement>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 5.6, horizontal: 10),
            height: snapshot.data.isEmpty ? 0 : size.width * 9 / 18,
            child: buildSwiper(bloc),
          );
        }
      },
    );
  }

  Swiper buildSwiper(ApiBloc bloc) {
    return Swiper(
      key: const PageStorageKey('announncement'),
      itemCount: bloc.announcement.length,
      loop: true,
      autoplay: true,
      viewportFraction: 0.8,
      scale: 0.8,
      autoplayDelay: 10000,
      autoplayDisableOnInteraction: false,
      itemBuilder: (BuildContext context, int index) =>
          buildInkWell(context, bloc, index),
    );
  }

  InkWell buildInkWell(BuildContext context, ApiBloc bloc, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnnouncementScreen(
              announcement: bloc.announcement[index],
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // width: size.width,
          color: cGray,
          child: CachedPicture(
            image: bloc.announcement[index].featureImage,
            boxFit: BoxFit.cover,
            isBackground: true,
          ),
        ),
      ),
    );
  }
}
