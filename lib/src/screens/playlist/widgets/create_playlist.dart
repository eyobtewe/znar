import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uuid/uuid.dart';

import '../../../core/core.dart';
import '../../../domain/models/models.dart';
import '../../../presentation/bloc.dart';

class CreatePlaylist extends StatefulWidget {
  const CreatePlaylist({Key key, this.song}) : super(key: key);
  final Song song;
  @override
  _CreatePlaylistState createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _playlistTitle;
  UiBloc uiBloc;
  ApiBloc bloc;

  @override
  void initState() {
    _playlistTitle = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _playlistTitle.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    uiBloc = UiProvider.of(context);
    bloc = ApiProvider.of(context);

    return AlertDialog(
      backgroundColor: CANVAS_BLACK,
      title: Text(Language.locale(uiBloc.language, 'create_playlist'),
          style: const TextStyle(
            fontFamilyFallback: f,
          )),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _playlistTitle,
          style: const TextStyle(fontFamilyFallback: f),
          validator: (String text) {
            if (text.isEmpty) {
              return Language.locale(uiBloc.language, 'please_write_title');
            } else {
              return null;
            }
          },
        ),
      ),
      actions: buildButtons(context),
    );
  }

  List<Widget> buildButtons(BuildContext context) {
    return [
      FlatButton.icon(
        onPressed: () async {
          Playlist playlist = Playlist(
            name: _playlistTitle.text,
            isLocal: true,
            sId: Uuid().v1(),
            featureImage: '',
          );
          int data = await bloc.savePlaylist(playlist);
          Fluttertoast.showToast(
            msg: Language.locale(
                uiBloc.language,
                data == null
                    ? 'create_playlist_failed'
                    : 'create_playlist_success'),
            backgroundColor: PURE_WHITE,
            textColor: BACKGROUND,
          );
          if (widget.song != null && data != null) {
            int songAddedOrNot =
                await bloc.addSongToPlaylist(widget.song, playlist);
            Fluttertoast.showToast(
              msg: songAddedOrNot != null
                  ? Language.locale(uiBloc.language, 'song_added')
                  : Language.locale(uiBloc.language, 'failed_song_added'),
              backgroundColor: PURE_WHITE,
              textColor: BACKGROUND,
            );
          }
          if (data != null) {
            _playlistTitle.clear();
            Navigator.pop(context);
          }
        },
        icon: const Icon(Ionicons.checkmark),
        label: Text(''),
      ),
      FlatButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.trash),
          label: Text('')),
    ];
  }
}
