import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'file_helper.dart';
import 'widgets/prompt_dialog.dart';
import 'dart:io';

class FolderNotExists implements Exception {}

class FolderAlreadyAdded implements Exception {}

class InvalidFolderPath implements Exception {}

class FolderSettingsView extends StatefulWidget {
  _FolderSettingsViewState createState() => _FolderSettingsViewState();
}

class _FolderSettingsViewState extends State<FolderSettingsView> {
  bool _initialized = false;
  List<String> _folders = [];
  FileHelper helper = FileHelper("db.json");
  @override
  void initState() {
    super.initState();
    _initFolders();
  }

  void _initFolders() async {
    List<String> watchingFolders = await helper.getWatchingFolders();
    setState(() {
      _initialized = true;
      _folders = watchingFolders;
    });
  }

  void _syncFolder() async {
    List<String> newWatchingFolders = await helper.getWatchingFolders();
    setState(() {
      _folders = newWatchingFolders;
    });
  }

  void _addFolder(String folderPath) async {
    List<String> watchingFolders = await helper.getWatchingFolders();
    if (folderPath.length == 0) {
      throw InvalidFolderPath();
    }
    if (await helper.existsFolder(folderPath)) {
      throw FolderAlreadyAdded();
    }
    Directory dir = Directory(folderPath);
    if (!(await dir.exists())) {
      throw FolderNotExists();
    }

    await helper.addFolder(folderPath);
    _syncFolder();
  }

  void _removeFolder(String folderPath) async {
    List<String> watchingFolders = await helper.getWatchingFolders();
    assert(await watchingFolders.contains(folderPath));

    await helper.removeFolder(folderPath);
    _syncFolder();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> folderWidgets = _folders.map((folder) {
      return ListTile(
        title: Text(folder),
        trailing: IconButton(
          icon: Icon(
            Icons.clear,
          ),
          onPressed: () {
            _removeFolder(folder);
          },
        ),
      );
    }).toList();
    return Scaffold(
      body: ListView(
        children: folderWidgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String txt = await showDialog(
            context: context,
            builder: (context) {
              return PromptDialog(
                title: 'Input Folder Path',
                hintText: 'Enter a Folder Path',
              );
            },
          );
          if (txt != null) {
            await _addFolder(txt);
          }
        },
        tooltip: "Add Folder",
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

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
            Text("Song"),
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
