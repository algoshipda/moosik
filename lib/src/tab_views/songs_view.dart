import 'package:flutter/material.dart';

import '../file_helper.dart';
import 'dart:io';

class SongsView extends StatefulWidget {
  @override
  _SongsViewState createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  List<Mp3File> _mp3Files = [];
  @override
  void initState() {
    super.initState();
    _initSongs();
  }

  void _initSongs() async {
    List<String> folderPaths = await fileHelper.getWatchingFolders();
    List<Mp3File> mp3Files = await Stream.fromIterable(folderPaths)
        .asyncMap((folderPath) {
          return fileHelper.getMp3Files(folderPath);
        })
        .asyncExpand((files) => Stream.fromIterable(files))
        .toList();

    setState(() => _mp3Files = mp3Files);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> mp3Widgets = [];
    for (Mp3File mp3File in _mp3Files) {
      mp3Widgets.add(ListTile(
          title: Text(mp3File.title),
          trailing: IconButton(
              icon: Icon(
                Icons.favorite_border,
              ),
              onPressed: () {})));
      mp3Widgets.add(Divider());
    }

    return Scaffold(
        body: ListView(
      children: mp3Widgets,
    ));
  }
}
