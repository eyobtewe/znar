import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/core.dart';

class CustomWebPage extends StatefulWidget {
  final String url;
  final String title;

  const CustomWebPage({Key key, @required this.url, this.title})
      : super(key: key);

  @override
  State<CustomWebPage> createState() => _CustomWebPageState();
}

class _CustomWebPageState extends State<CustomWebPage> {
  InAppWebViewController webView;
  // String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  // void showToast(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     backgroundColor: BLACK,
  //     textColor: WHITE,
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.BOTTOM,
  //   );
  // }

  bool isLoading = false;
  double height = 10;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // showToast('Loading...');

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   // backgroundColor: cTransparent,
        //   iconTheme: IconThemeData(color: BLACK),
        //   elevation: height,
        //   toolbarHeight: 48,
        // ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          backgroundColor: cPrimaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onProgressChanged: (InAppWebViewController controller, int pro) {
                setState(() {
                  progress = pro / 100;
                  if (progress == 100) {
                    height = 0;
                  }
                });
              },
            ),
            progress < 1.0
                ? Positioned(
                    bottom: 0,
                    width: size.width,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: cPrimaryColor.withOpacity(0.25),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(cPrimaryColor),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
