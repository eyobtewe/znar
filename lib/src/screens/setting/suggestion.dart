import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';

import '../../core/core.dart';
import '../../presentation/ui_provider.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController artistNameController;
  TextEditingController detailController;
  TextEditingController songTitleController;
  String artistName, songTitle, detail;

  @override
  void initState() {
    super.initState();
    artistNameController = TextEditingController();
    detailController = TextEditingController();
    songTitleController = TextEditingController();
  }

  @override
  void dispose() {
    artistNameController.dispose();
    detailController.dispose();
    songTitleController.dispose();
    super.dispose();
  }

  UiBloc uiBloc;
  Size size;
  @override
  Widget build(BuildContext context) {
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: size.width,
                padding: const EdgeInsets.only(bottom: 10, left: 10),
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
                  SizedBox(
                    width: size.width * 0.45,
                    child: buildartistNameField(false),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: size.width * 0.45,
                    child: buildartistNameField(true),
                  ),
                ],
              ),
              const Divider(color: cTransparent),
              buildDetailField(),
              const Divider(color: cTransparent),
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

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: const Text(
                'Thank you for the suggestion',
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: cPrimaryColor,
            ),
          );
        }
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all<Color>(cPrimaryColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(color: cBackgroundColor),
      ),
    );
  }

  TextFormField buildartistNameField(bool artist) {
    return TextFormField(
      cursorColor: cPrimaryColor,
      maxLines: 1,
      controller: artist ? artistNameController : songTitleController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: '${artist ? 'Artist' : 'Song'} (optional)',
        labelStyle: const TextStyle(fontFamilyFallback: f),
      ),
      onSaved: (input) => input != null
          ? (artist ? artistName = input : songTitle = input)
          : null,
    );
  }

  TextFormField buildDetailField() {
    return TextFormField(
      cursorColor: cPrimaryColor,
      maxLines: null,
      minLines: 7,
      controller: detailController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: 'Description or link',
        labelStyle: const TextStyle(fontFamilyFallback: f),
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

// void sendMail(String artist, String title, String description) async {
//   String username = 'username@gmail.com';
//   String password = 'password';

//   // final smtpServer = gmail(username, password);

//   // Create our message.
//   final message = Message()
//     ..from = Address(username, 'Your name')
//     ..recipients.add('destination@example.com')
//     ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
//     ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//     ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

//   try {
//     final sendReport = await send(message, smtpServer);
//     debugPrint('Message sent: ' + sendReport.toString());
//   } on MailerException catch (e) {
//     debugPrint('Message not sent.');
//     for (var p in e.problems) {
//       debugPrint('Problem: ${p.code}: ${p.msg}');
//     }
//   }
//   // DONE
// }
