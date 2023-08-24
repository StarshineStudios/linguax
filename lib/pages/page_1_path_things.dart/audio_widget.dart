import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test2/constants.dart';

import 'package:hive_flutter/hive_flutter.dart';

class AudioWidget extends StatefulWidget {
  //a string that tell the location of the audio RELATIVE to the assets folder
  final String assetSource;
  final String title;
  final String id;
  final Box<dynamic> box;
  const AudioWidget({
    super.key,
    required this.assetSource,
    required this.box,
    required this.id,
    required this.title,
  });

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  bool isPlaying = true;
  late final AudioPlayer player;
  late final AssetSource path;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    initPlayer();
    super.initState();
    player.play(path);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future initPlayer() async {
    player = AudioPlayer();
    path = AssetSource(widget.assetSource);

    //for duration change
    player.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

    //for position change
    player.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    //for when audio ends
    player.onPlayerComplete.listen((_) {
      setState(() => _position = _duration);
      widget.box.put(widget.id, true);
      Navigator.of(context).pop(); //goes back when done
    });
  }

  void playPause() async {
    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      player.play(path);
      isPlaying = true;
    }
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'We reccomend finishing an audio lesson in one sitting. Do you really want to go back?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // Allow navigation back
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay on the page
                child: const Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes - 60 * duration.inHours);
    final seconds = twoDigits(duration.inSeconds -
        60 * 60 * duration.inHours -
        60 * duration.inMinutes);

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          foregroundColor: secondaryColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.title),
                  const SizedBox(
                    height: 16,
                  ),
                  Slider(
                    value: _position.inMicroseconds.toDouble(),
                    onChanged: (value) async {
                      await player.seek(Duration(microseconds: value.toInt()));
                      //optional, I make it resume when the thing is scrubbbed
                      //as of now it does not work FIND OUT WHY!!!!!!!
                      // setState(() async {
                      //   await player.resume();
                      //   isPlaying = true;
                      // });
                    },
                    min: 0,
                    max: _duration.inMicroseconds.toDouble(),
                    inactiveColor: Colors.grey,
                    activeColor: mainColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(_position)),
                      Text(formatTime(_duration)),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          player.seek(Duration(
                              microseconds:
                                  _position.inMicroseconds - 10 * 1000000));
                        },
                        child: const Icon(
                          Icons.replay_10,
                          color: mainColor,
                          size: 100,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: playPause,
                        child: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: mainColor,
                          size: 100,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () {
                          player.seek(Duration(
                              microseconds:
                                  _position.inMicroseconds + 10 * 1000000));
                        },
                        child: const Icon(
                          Icons.forward_10,
                          color: mainColor,
                          size: 100,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
