import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<io.File> _files = [];
  PersistentBottomSheetController bottomSheetController;

  @override
  void initState() {
    _findRecordFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeData.dark().dividerColor,
        ),
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) => ListTile(
          title: Text(_files[index].path.split('/').last),
          subtitle: Text(
              _files[index].lastModifiedSync().toString().split('.').first),
          onTap: () {
            _playSound(_files[index].path);
            _showBottomSheet(context);
          },
          onLongPress: () {
            _closeBottomSheet();
          },
        ),
        itemCount: _files.length,
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

  void _showBottomSheet(BuildContext context) {
    bottomSheetController = showBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        decoration: BoxDecoration(
          color: ThemeData.dark().cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.skip_previous,
                    size: 40.0,
                  ),
                  Icon(
                    Icons.play_arrow,
                    size: 60.0,
                  ),
                  Icon(
                    Icons.skip_next,
                    size: 40.0,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('00:00'),
                  Expanded(
                    child: Slider(
                      value: 0.0,
                      onChanged: (value) {},
                    ),
                  ),
                  Text('00:00'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _closeBottomSheet() {
    bottomSheetController.close();
  }
}
