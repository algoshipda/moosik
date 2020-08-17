import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'file_helper.dart';

import 'tab_views/folder_settings_view.dart';
import 'tab_views/songs_view.dart';
import 'dart:io';

class _MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.mic)),
              Tab(icon: Icon(Icons.album)),
              Tab(icon: Icon(Icons.music_note)),
              Tab(icon: Icon(Icons.folder)),
            ],
          ),
          title: Text('Moosik'),
        ),
        body: TabBarView(
          children: [
            Text("artist"),
            Text("album"),
            SongsView(),
            FolderSettingsView(),
          ],
        ),
      ),
    );
  }
}

class Moosik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moosik',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _MyHomePage(),
    );
  }
}
