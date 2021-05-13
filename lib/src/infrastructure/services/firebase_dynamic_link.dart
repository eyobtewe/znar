import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../../domain/models/models.dart';

final kDynamicLinkService = DynamicLinkService();

class DynamicLinkService {
  Map<String, String> dynamicLinkDetected;

  Future handleDynamicLinks({Function(Map<String, String>) onLinkFound}) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      dynamicLinkDetected = await _handleDynamicLink(data);
      onLinkFound(dynamicLinkDetected);
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
        dynamicLinkDetected = await _handleDynamicLink(dynamicLinkData);
        onLinkFound(dynamicLinkDetected);
      },
    );
  }

  Future<Map<String, String>> _handleDynamicLink(
      PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      return {
        '${deepLink.queryParameters.values.single}':
            '${deepLink.queryParameters.keys.single}',
      };
    }
    return null;
  }

  Future<String> createDynamicLink(dynamic entity) async {
    switch (entity.runtimeType) {
      case Artist:
        return await _createDynamicLink(entity.sId, entity.photo, 'artist');
      // case Album:
      //   return await _createDynamicLink(
      //       entity.sId, entity.albumArt, 'album');
      case Song:
        return await _createDynamicLink(entity.sId, entity.coverArt, 'song');
      case Playlist:
        return await _createDynamicLink(
            entity.sId, entity.featureImage, 'playlist');
      // case Channel:
      //   return await _createDynamicLink(entity.sId, entity.banner, 'channel');
      case MusicVideo:
        return await _createDynamicLink(
            entity.sId, entity.thumbnail, 'musicvideo');
      // case Announcement:
      //   return await _createDynamicLink(
      //       entity.sId, entity.featureImage, 'announcement');
      default:
        return null;
    }
  }

  Future<String> _createDynamicLink(
      String id, String imgUrl, String type) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://znarmusica.page.link',
      link: Uri.parse('https://znarmusica.com/p?$type=$id'),
      androidParameters: AndroidParameters(
        packageName: 'music.streaming.znar',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'music.streaming.znar',
        // appStoreId: '1558631041',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'ZNAR',
        description: '',
        imageUrl: Uri.parse('$imgUrl'),
      ),
    );
    ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    Uri shortUrl = shortDynamicLink.shortUrl;
    // Uri shortUrl = await parameters.buildUrl();

    return '$shortUrl';
  }
}
