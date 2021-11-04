import 'package:clearit_server/utility/functions/showToast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart' as ap;

import 'AudioPlayer.dart';

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorder({required this.onStop});

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;

  @override
  void initState() {
    _isRecording = false;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildRecordStopControl(),
              const SizedBox(width: 20),
              _buildPauseResumeControl(),
              const SizedBox(width: 20),
              _buildText(),
            ],
          ),
          // if (_amplitude != null) ...[
          //   const SizedBox(height: 40),
          //   Text('Current: ${_amplitude?.current ?? 0.0}'),
          //   Text('Max: ${_amplitude?.max ?? 0.0}'),
          // ],
        ],
      ),
    );
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_isRecording || _isPaused) {
      icon = Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isRecording ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (!_isRecording && !_isPaused) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (!_isPaused) {
      icon = Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isPaused ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    }

    return Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();

    widget.onStop(path!);

    setState(() => _isRecording = false);
  }

  Future<void> _pause() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }
}

class RecordAudioScreen extends StatefulWidget {
  @override
  _RecordAudioScreenState createState() => _RecordAudioScreenState();
}

String? pathToAudio;

class _RecordAudioScreenState extends State<RecordAudioScreen> {
  bool showPlayer = false;
  ap.AudioSource? audioSource;

  @override
  void initState() {
    showPlayer = false;
    checkPermission(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: showPlayer
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: AudioPlayer(
                      source: audioSource!,
                      onDelete: () {
                        setState(() => showPlayer = false);
                      },
                    ),
                  )
                : AudioRecorder(
                    onStop: (path) {
                      setState(() {
                        audioSource = ap.AudioSource.uri(Uri.parse(path));
                        showPlayer = true;
                        pathToAudio = path;
                        print("path is $path");
                      });
                    },
                  ),
          ),
          // Text("path is $pathToAudio"),
          showPlayer
              ? TextButton(
                  onPressed: () {
                    Navigator.pop(context, pathToAudio);
                  },
                  child: Text("Submit"))
              : Container(),
        ],
      ),
    );
  }
}

Future<bool> checkPermission(BuildContext context) async {
  var status = Permission.storage;
  var audioStatus = Permission.microphone;
  await Record().hasPermission();

  if (await status.isDenied || await audioStatus.isDenied) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.microphone,
    ].request();
    print(statuses[Permission.storage]);
  } else if (await Permission.storage.isPermanentlyDenied) {
    showToast("Give storage permission");
    openAppSettings();
  }

// You can can also directly ask the permission about its status.
  if (await Permission.storage.isRestricted) {
    // The OS
    showToast("Give storage permission");
  }
  if (await status.isGranted) {
    return true;
  }
  return false;
}
