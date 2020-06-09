import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'dart:io' as io;

class RecorderScreen extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  RecorderScreen({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  FlutterAudioRecorder _recorder;
  Recording _recordingFile;
  RecordingStatus _recordingStatus = RecordingStatus.Unset;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${_recordingFile?.duration.toString().split('.').first.padLeft(8, "0")}',
                style: TextStyle(fontSize: 70.0),
              ),
              Center(
                child: Container(
                  height: 100.0,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Opacity(
                        opacity:
                            _recordingStatus == RecordingStatus.Recording ||
                                    _recordingStatus == RecordingStatus.Paused
                                ? 1.0
                                : 0.0,
                        child: Container(
                          height: 80.0,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            iconSize: 40.0,
                            icon: Icon(Icons.stop),
                            color: Colors.red,
                            onPressed: () {
                              print('Stop button tapped');
                              _stop();
                              _init();
                            },
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring:
                            _recordingStatus == RecordingStatus.Recording ||
                                    _recordingStatus == RecordingStatus.Paused
                                ? true
                                : false,
                        child: Opacity(
                          opacity:
                              _recordingStatus == RecordingStatus.Recording ||
                                      _recordingStatus == RecordingStatus.Paused
                                  ? 0.0
                                  : 1.0,
                          child: Container(
                            height: 80.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    width: 56.0,
                                    height: 56.0,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  iconSize: 60.0,
                                  icon: Icon(Icons.lens),
                                  color: Colors.red,
                                  onPressed: () {
                                    print('Record button tapped');
                                    _start();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _recordingStatus == RecordingStatus.Paused
                            ? 1.0
                            : 0.0,
                        child: Align(
                          alignment: Alignment(0.25, 1.0),
                          child: Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              iconSize: 20.0,
                              color: ThemeData.dark().scaffoldBackgroundColor,
                              icon: Icon(Icons.redo),
                              onPressed: () {
                                print('Resume button tapped');
                                _resume();
                              },
                            ),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: _recordingStatus != RecordingStatus.Recording
                            ? true
                            : false,
                        child: Opacity(
                          opacity: _recordingStatus == RecordingStatus.Recording
                              ? 1.0
                              : 0.0,
                          child: Align(
                            alignment: Alignment(0.25, 1.0),
                            child: Container(
                              width: 35.0,
                              height: 35.0,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                iconSize: 20.0,
                                color: ThemeData.dark().scaffoldBackgroundColor,
                                icon: Icon(Icons.pause),
                                onPressed: () {
                                  print('Pause button tapped');
                                  _pause();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Text('Peak Power: ${_recordingFile?.metering?.peakPower}'),
            ]),
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/BAR_';
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _recordingFile = current;
          _recordingStatus = current.status;
          print(_recordingStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _recordingFile = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_recordingStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _recordingFile = current;
          _recordingStatus = _recordingFile.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _recordingFile = result;
      _recordingStatus = _recordingFile.status;
    });
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_recordingStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Init';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_recordingFile.path, isLocal: true);
  }
}
