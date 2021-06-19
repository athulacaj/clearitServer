import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioWidget extends StatefulWidget {
  final String url;
  AudioWidget({this.url});
  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

AudioPlayer audioPlayer = AudioPlayer();
bool _isPlaying = false;
bool _isAlreadyPlayed = false;

class _AudioWidgetState extends State<AudioWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        height: 60,
        width: size.width * .5,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            // Text('Audio '),
            // SizedBox(width: 10),
            IconButton(
                icon: _isPlaying
                    ? Icon(Icons.pause, color: Colors.blue)
                    : Icon(Icons.play_arrow, color: Colors.blue),
                onPressed: () async {
                  if (_isPlaying) {
                    int result = await audioPlayer.pause();
                    if (result == 1) {
                      _isPlaying = false;
                      setState(() {});
                    }
                  } else {
                    if (_isAlreadyPlayed) {
                      int result = await audioPlayer.resume();
                      if (result == 1) {
                        _isPlaying = true;
                        setState(() {});
                      }
                    } else {
                      int result = await audioPlayer.play(widget.url);
                      print(result);
                      if (result == 1) {
                        _isPlaying = true;
                        setState(() {});
                      }
                      _isAlreadyPlayed = true;
                      setState(() {});
                    }
                  }
                }),
            SizedBox(width: 20),
            _isPlaying
                ? IconButton(
                    icon: Icon(Icons.stop, color: Colors.blue),
                    onPressed: () async {
                      int result = await audioPlayer.stop();
                      if (result == 1) {
                        _isPlaying = false;
                        setState(() {});
                      }
                    })
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() async {
    // TODO: implement deactivate
    await audioPlayer.stop();
    _isPlaying = false;
    _isAlreadyPlayed = false;
    super.deactivate();
  }
}
