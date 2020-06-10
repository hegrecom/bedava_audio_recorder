import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<io.File> _files;

  @override
  void initState() {
    _findRecordFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: _files != null
            ? _files
                .map((e) => ListTile(
                      title: Text(e.path.split('/').last),
                      onTap: () {
                        _playSound(e.path);
                      },
                    ))
                .toList()
            : [],
      ),
    );
  }

  void _findRecordFiles() async {
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    List<io.FileSystemEntity> fileEntities = appDocDirectory.listSync();
    _files = fileEntities
        .where((element) => element is io.File)
        .where((element) =>
            ['wav', 'mp4', 'aac', 'm4a'].contains(element.path.split('.').last))
        .map((e) => e as io.File)
        .toList();

    setState(() {
      _files.sort((file1, file2) => file2.path.compareTo(file1.path));
    });
  }

  void _playSound(String path) async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(path, isLocal: true);
  }
}
