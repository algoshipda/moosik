import 'package:flutter/material.dart';

import '../file_helper.dart';
import 'dart:io';
import '../widgets/prompt_dialog.dart';

class FolderNotExists implements Exception {}

class FolderAlreadyAdded implements Exception {}

class InvalidFolderPath implements Exception {}

class FolderSettingsView extends StatefulWidget {
  _FolderSettingsViewState createState() => _FolderSettingsViewState();
}

class _FolderSettingsViewState extends State<FolderSettingsView> {
  bool _initialized = false;
  List<String> _folders = [];
  @override
  void initState() {
    super.initState();
    _initFolders();
  }

  void _initFolders() async {
    List<String> watchingFolders = await fileHelper.getWatchingFolders();
    setState(() {
      _initialized = true;
      _folders = watchingFolders;
    });
  }

  void _syncFolder() async {
    List<String> newWatchingFolders = await fileHelper.getWatchingFolders();
    setState(() {
      _folders = newWatchingFolders;
    });
  }

  void _addFolder(String folderPath) async {
    List<String> watchingFolders = await fileHelper.getWatchingFolders();
    if (folderPath.length == 0) {
      throw InvalidFolderPath();
    }
    if (await fileHelper.existsFolder(folderPath)) {
      throw FolderAlreadyAdded();
    }
    Directory dir = Directory(folderPath);
    if (!(await dir.exists())) {
      throw FolderNotExists();
    }

    await fileHelper.addFolder(folderPath);
    _syncFolder();
  }

  void _removeFolder(String folderPath) async {
    List<String> watchingFolders = await fileHelper.getWatchingFolders();
    assert(await watchingFolders.contains(folderPath));

    await fileHelper.removeFolder(folderPath);
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
