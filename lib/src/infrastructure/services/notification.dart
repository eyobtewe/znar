import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/models/models.dart';

class CustomNotification {
  FlutterLocalNotificationsPlugin noti;
  CustomNotification() {
    notificationInit();
  }

  Future notificationInit() async {
    noti = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // await noti.initialize(
    //   InitializationSettings(
    //     AndroidInitializationSettings('ic_music'),
    //     IOSInitializationSettings(),
    //   ),
    // );
    await noti.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('ic_music'),
        iOS: IOSInitializationSettings(),
      ),
    );
  }

  Future showProgressNotification(int progress, Song song) async {
    var androidProgress = AndroidNotificationDetails(
      'progress channel',
      'progress channel',
      'progress channel description',
      channelShowBadge: false,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      playSound: false,
    );

    // var platformChannelSpecifics = NotificationDetails(
    //   progress != 100 && progress != -1 ? androidProgress : androidDone,
    //   iOS,
    // );
    var platformChannelSpecifics = NotificationDetails(
      android:
          progress != 100 && progress != -1 ? androidProgress : androidDone,
      iOS: iOS,
    );

    final int id = song.title.length * song.filePath.length;
    switch (progress) {
      case -1:
        return await noti.show(
          id,
          'Download failed',
          '',
          platformChannelSpecifics,
        );
      case 100:
        return await noti.show(
          id,
          'Download finished',
          song.artistStatic.stageName + ' ' + song.title,
          platformChannelSpecifics,
        );
      default:
        return await noti.show(
          id,
          'Downloading',
          song.artistStatic.stageName + ' ' + song.title,
          platformChannelSpecifics,
          payload: song.sId,
        );
    }
  }
}

const AndroidNotificationDetails androidDone = AndroidNotificationDetails(
  'progress channel',
  'progress channel',
  'progress channel description',
  channelShowBadge: false,
  onlyAlertOnce: true,
  showProgress: false,
  maxProgress: 100,
  playSound: false,
);
const IOSNotificationDetails iOS = IOSNotificationDetails(
  presentSound: false,
  presentAlert: false,
  presentBadge: false,
);
