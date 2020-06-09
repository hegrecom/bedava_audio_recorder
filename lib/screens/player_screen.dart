import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

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
                      title: Text(e.path),
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
    setState(() {
      _files = fileEntities
          .where((element) => element is io.File)
          .map((e) => e as io.File)
          .toList();
    });
  }
}
