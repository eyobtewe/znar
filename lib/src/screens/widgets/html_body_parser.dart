import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlBody extends StatelessWidget {
  const HtmlBody({this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
    );
  }
}
