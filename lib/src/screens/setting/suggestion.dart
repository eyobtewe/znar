import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../core/core.dart';
import '../../presentation/ui_provider.dart';

class SuggestionScreen extends StatefulWidget {
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController artistNameController;
  TextEditingController detailController;
  TextEditingController songTitleController;
  String artistName, songTitle, detail;

  void initState() {
    super.initState();
    artistNameController = TextEditingController();
    detailController = TextEditingController();
    songTitleController = TextEditingController();
  }

  void dispose() {
    artistNameController.dispose();
    detailController.dispose();
    songTitleController.dispose();
    super.dispose();
  }

  UiBloc uiBloc;
  Size size;
  Widget build(BuildContext context) {
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suggestion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamilyFallback: f,
          ),
        ),
      ),
      body: buildBody(),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: size.width,
                padding: EdgeInsets.only(bottom: 10, left: 10),
                child: Text(
                  'Please describe the song you want',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontFamilyFallback: f,
                  ),
                  maxLines: 1,
                ),
              ),
              Row(
                children: [
                  Container(
                    child: buildartistNameField(false),
                    width: size.width * 0.45,
                  ),
                  Spacer(),
                  Container(
                    child: buildartistNameField(true),
                    width: size.width * 0.45,
                  ),
                ],
              ),
              Divider(color: TRANSPARENT),
              buildDetailField(),
              Divider(color: TRANSPARENT),
              buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return TextButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          await sendFeedback();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Text(
                'Thank you for the suggestion',
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: PRIMARY_COLOR,
            ),
          );
        }
      },
      child: Text(
        'Submit',
        style: TextStyle(color: BACKGROUND),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all<Color>(PRIMARY_COLOR),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }

  TextFormField buildartistNameField(bool artist) {
    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      maxLines: 1,
      controller: artist ? artistNameController : songTitleController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: (artist ? 'Artist' : 'Song') + ' (optional)',
        labelStyle: TextStyle(fontFamilyFallback: f),
      ),
      onSaved: (input) => input != null
          ? (artist ? artistName = input : songTitle = input)
          : null,
    );
  }

  TextFormField buildDetailField() {
    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      maxLines: null,
      minLines: 7,
      controller: detailController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: 'Description or link',
        labelStyle: TextStyle(fontFamilyFallback: f),
      ),
      validator: (input) => input != null
          ? ((input.length < 6)
              ? 'Please write some detail to help us find the song '
              : null)
          : null,
      onSaved: (input) => input != null ? (detail = input) : null,
    );
  }

  Future sendFeedback() async {
    artistNameController.clear();
    songTitleController.clear();
    detailController.clear();
    setState(() {});
  }
}

void sendMail(String artist, String title, String description) async {
  String username = 'username@gmail.com';
  String password = 'password';

  final smtpServer = gmail(username, password);

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Your name')
    ..recipients.add('destination@example.com')
    ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  try {
    final sendReport = await send(message, smtpServer);
    debugPrint('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    debugPrint('Message not sent.');
    for (var p in e.problems) {
      debugPrint('Problem: ${p.code}: ${p.msg}');
    }
  }
  // DONE
}
