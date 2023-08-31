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
  final String imageCaption;

  final String imageSource;
  const AudioWidget({
    super.key,
    required this.assetSource,
    required this.box,
    required this.id,
    required this.title,
    required this.imageSource,
    required this.imageCaption,
  });

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  bool isPlaying = false;
  late final AudioPlayer player;
  late final AssetSource path;

  Duration _duration = const Duration();

  Duration _position = const Duration();

  int count = 0;

  @override
  void initState() {
    initPlayer();
    super.initState();
    playPause();
    //player.play(path); //start the thing
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future initPlayer() async {
    player = AudioPlayer();
    path = AssetSource(widget.assetSource);

    bool wasFinished =
        widget.box.get('${widget.id}finished', defaultValue: false);

    int previousStartPositionMicroseconds =
        widget.box.get('${widget.id}position', defaultValue: 0);

    //for duration change bc it may chnage many times during setup
    player.onDurationChanged.listen((Duration d) async {
      setState(() => _duration = d);

      int startPositionMicroseconds;

      //if it was restarted, then just start at the begining
      if (wasFinished) {
        //widget.box.put('${widget.id}finished', false);
        /*this is commented out because it was bad and 
        it make it so that rewatching it would make it 
        not finished therefore making the lessons dependent 
        on it locked*/
        startPositionMicroseconds = 0;
      } else {
        startPositionMicroseconds = previousStartPositionMicroseconds;
      }
      player.seek(Duration(microseconds: startPositionMicroseconds));
    });

    //for position change
    player.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    //for when audio ends
    player.onPlayerComplete.listen((_) {
      setState(() => _position = _duration);
      widget.box.put('${widget.id}finished', true);

      widget.box.put('${widget.id}position', 1);
      widget.box.put('${widget.id}duration', 1); //sets it as 100 percent
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
            backgroundColor: mainColorBackground,
            title: const Text('Warning'),
            content: const Text(
                'We reccomend finishing an audio lesson in one sitting. Do you really want to go back?'),
            actions: [
              NiceButton(
                onPressed: () {
                  widget.box
                      .put('${widget.id}position', _position.inMicroseconds);
                  widget.box
                      .put('${widget.id}duration', _duration.inMicroseconds);

                  Navigator.of(context).pop(true);
                }, // Allow navigation back
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  child: Text('Yes'),
                ),
              ),
              NiceButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                }, // Stay on the page
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  child: Text('No'),
                ),
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
        backgroundColor: mainColorBackground,
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultRadius),
                      color: mainColor,
                    ),
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.imageSource),
                          colorFilter: const ColorFilter.mode(
                              mainColor, BlendMode.softLight),

                          ///makes the image black and white if locked
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 200,
                              ),
                              const Text(
                                'Latin',
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.title,
                                style: const TextStyle(
                                    color: secondaryColor,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: mainColorDarker,
                        borderRadius: BorderRadius.circular(defaultRadius)),
                    child: Column(
                      children: [
                        Slider(
                          value: _position.inMicroseconds.toDouble(),
                          onChanged: (value) async {
                            await player
                                .seek(Duration(microseconds: value.toInt()));

                            //optional, I make it resume when the thing is scrubbbed
                            //as of now it does not work FIND OUT WHY!!!!!!!
                            // setState(() async {
                            //   await player.resume();
                            //   isPlaying = true;
                            // });
                          },
                          min: 0,
                          //some audio clips have their real time 4:00:01, and therefore this number is already greater than 4:00:00
                          max: _duration.inMicroseconds.toDouble() + 2,
                          inactiveColor: Colors.grey,
                          activeColor: mainColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatTime(_position)),
                              Text(formatTime(_duration)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NiceButton(
                              borderRadius: 100,
                              onPressed: () {
                                player.seek(Duration(
                                    microseconds: _position.inMicroseconds -
                                        10 * 1000000));
                              },
                              child: const Icon(
                                Icons.replay_10,
                                color: secondaryColor,
                                size: 100,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            NiceButton(
                              borderRadius: 100,
                              onPressed: playPause,
                              child: Icon(
                                isPlaying
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                color: secondaryColor,
                                size: 100,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            NiceButton(
                              borderRadius: 100,
                              onPressed: () {
                                player.seek(Duration(
                                    microseconds: _position.inMicroseconds +
                                        10 * 1000000));
                              },
                              child: const Icon(
                                Icons.forward_10,
                                color: secondaryColor,
                                size: 100,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: mainColorDarker,
                        borderRadius: BorderRadius.circular(defaultRadius)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              widget.imageCaption,
                              style: const TextStyle(color: secondaryColor),
                            ),
                            const SizedBox(
                              height: 66,
                            ),
                          ],
                        ),
                      ),
                    ),
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