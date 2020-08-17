import 'package:flutter/material.dart';

class _MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.mic)),
              Tab(icon: Icon(Icons.album)),
              Tab(icon: Icon(Icons.music_note)),
            ],
          ),
          title: Text('Moosik'),
        ),
        body: TabBarView(
          children: [
            Text("artist"),
            Text("album"),
            Text("Song"),
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

