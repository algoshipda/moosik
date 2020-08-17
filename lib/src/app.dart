import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'file_helper.dart';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    List<Widget> folderWidgets = _folders.map((folder) {
      return ListTile(
        title: Text(folder),
      );
    }).toList();
    return Scaffold(
      body: ListView(
        children: folderWidgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Directory dir = Directory('/sdcard');
          print(dir.listSync());
          print(dir.path);
          Navigator.of(context).push<FolderPickerPage>(
              MaterialPageRoute(builder: (BuildContext context) {
            return FolderPickerPage(
                rootDirectory: dir,
                action: (BuildContext context, Directory folder) async {
                  print("Picked folder $folder");
                });
          }));
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
