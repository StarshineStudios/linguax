import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioWidget extends StatefulWidget {
  final String
      assetSource; //a string that tell the location of the audio RELATIVE to the assets folder
  const AudioWidget({super.key, required this.assetSource});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  bool isPlaying = false;
  late final AudioPlayer player;
  late final AssetSource path;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    initPlayer();
    super.initState();
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
      Navigator.of(context).pop(); //goes back.
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Question Pages')),
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
                  const Text('EXAMPLE TEXT'),
                  const SizedBox(
                    height: 16,
                  ),
                  Slider(
                    value: _position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      await player.seek(Duration(seconds: value.toInt()));
                      //optional, I make it resume when the thing is scrubbbed
                      //as of now it does not work FIND OUT WHY!!!!!!!
                      // setState(() async {
                      //   await player.resume();
                      //   isPlaying = true;
                      // });
                    },
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    inactiveColor: Colors.grey,
                    activeColor: Colors.red,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(_duration.toString()), //fix later!
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
                          player.seek(
                              Duration(seconds: _position.inSeconds - 10));
                        },
                        child: Image.asset('assets/tenBack.png'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: playPause,
                        child: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.red,
                          size: 100,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () {
                          player.seek(
                              Duration(seconds: _position.inSeconds + 10));
                        },
                        child: Image.asset('assets/tenForward.png'),
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
