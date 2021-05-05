import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../core/colors.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../widgets/custom_loader.dart';

class CustomWebPage extends StatefulWidget {
  final String url;
  final String title;
  final MusicVideo musicVideo;

  const CustomWebPage({@required this.url, this.title, this.musicVideo});

  @override
  _CustomWebPageState createState() => _CustomWebPageState();
}

class _CustomWebPageState extends State<CustomWebPage> {
  void initState() {
    super.initState();
  }

  void showToast(String message) {
    ScaffoldMessengerState().showSnackBar(
      SnackBar(
        backgroundColor: BLUE,
        content: Text(message),
      ),
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    showToast('Loading...');
    final bloc = ApiProvider.of(context);
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        // actions: [
        //   widget.musicVideo == null
        //       ? Container()
        //       : IconButton(
        //           icon: const Icon(Icons.share),
        //           onPressed: () async {
        //             final String link = await bloc.dynamikLinkService
        //                 .createDynamicLink(widget.musicVideo);

        //             Share.share(
        //                 'Watch ${widget.musicVideo.artistStatic?.stageName ?? ''} - ${widget.musicVideo.title ?? ''} on IAAM streaming app \n$link');
        //           },
        //         ),
        // ],
        backgroundColor: TRANSPARENT,
        elevation: 0,
        centerTitle: false,
        title: widget.title != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  widget.musicVideo != null
                      ? 'IAAM'
                      : widget.title.toUpperCase() ?? '',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              )
            : Container(),
      ),
      initialChild: const CustomLoader(),
      supportMultipleWindows: true,
      resizeToAvoidBottomInset: true,
      allowFileURLs: true,
    );
  }
}
