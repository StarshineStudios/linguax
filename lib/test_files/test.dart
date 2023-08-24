import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Multiple Choice Example')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////

// class Word {
//   String lemma;
//   String language;

//   Word({
//     required this.lemma,
//     required this.language,
//   });
// }

//maybe use a map to store key value pairs for declension/conjugation? Maybe a list???
//Think about this later HARD!!!

// List<Word> words = [
//   Word(lemma: 'normalis', language: 'Latin'),
// ];

// const favoritesBox = 'favorite_books';
// const List<String> books = [
//   'Harry Potter',
//   'To Kill a Mockingbird',
//   'The Hunger Games',
//   'The Giver',
//   'Brave New World',
//   'Unwind',
//   'World War Z',
//   'The Lord of the Rings',
//   'The Hobbit',
//   'Moby Dick',
//   'War and Peace',
//   'Crime and Punishment',
//   'The Adventures of Huckleberry Finn',
//   'Catch-22',
//   'The Sound and the Fury',
//   'The Grapes of Wrath',
//   'Heart of Darkness',
// ];

// void main() async {
//   await Hive.initFlutter();
//   await Hive.openBox<String>(favoritesBox);
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Box<String> favoriteBooksBox;

//   @override
//   void initState() {
//     super.initState();
//     favoriteBooksBox = Hive.box(favoritesBox);
//   }

//   Widget getIcon(int index) {
//     if (favoriteBooksBox.containsKey(index)) {
//       return const Icon(Icons.star, color: Colors.amber);
//     }
//     return const Icon(Icons.star_border);
//   }

//   void onFavoritePress(int index) {
//     if (favoriteBooksBox.containsKey(index)) {
//       favoriteBooksBox.delete(index);
//       return;
//     }
//     favoriteBooksBox.put(index, books[index]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Favorite Books',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Favorite Books'),
//         ),
//         body: ValueListenableBuilder(
//           valueListenable: favoriteBooksBox.listenable(),
//           builder: (context, Box<String> box, _) {
//             return ListView.builder(
//               itemCount: books.length,
//               itemBuilder: (context, listIndex) {
//                 return ListTile(
//                   title: Text(books[listIndex]),
//                   trailing: IconButton(
//                     icon: getIcon(listIndex),
//                     onPressed: () => onFavoritePress(listIndex),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class LocalAudioPlayer extends StatefulWidget {
//   const LocalAudioPlayer({super.key});

//   @override
//   State<LocalAudioPlayer> createState() => _LocalAudioPlayerState();
// }

// class _LocalAudioPlayerState extends State<LocalAudioPlayer> {
//   final audioPlayer = AudioPlayer();

//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     setAudio();
//     //listen to the event: playing, paused or stopped
//     audioPlayer.onPlayerStateChanged.listen((event) {
//       setState(() {
//         isPlaying = event == PlayerState.PLAYING;
//       });
//     });

//     //Listen to the audio duration
//     audioPlayer.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration = newDuration;
//       });
//     });

//     //listen to the audio position
//     audioPlayer.onAudioPositionChanged.listen((newPostition) {
//       setState(() {
//         position = newPostition;
//       });
//     });
//   }

//   Future setAudio() async {
//     //Loop audio
//     //audioPlayer.setReleaseMode(ReleaseMode.LOOP);

//     //audio from INTERNET
//     // String url = 'url';
//     // audioPlayer.setUrl(url);

//     //audio from FILE
//     final player = AudioCache(prefix: 'assets/');
//     final url =
//         await player.load('orchestra-string-section-tune-SBA-300120703.mp3');
//     audioPlayer.setUrl(url.path, isLocal: true);
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   String formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes);
//     final seconds = twoDigits(duration.inSeconds);

//     return [
//       if (duration.inHours > 0) hours,
//       minutes,
//       seconds,
//     ].join(':');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Image.network(
//             'https://i.kym-cdn.com/entries/icons/original/000/036/026/biggus.jpg',
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//         ),
//         const SizedBox(height: 32),
//         const Text(
//           'title',
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 32),
//         Slider(
//           min: 0,
//           max: duration.inSeconds.toDouble(),
//           value: position.inSeconds.toDouble(),
//           onChanged: (value) async {
//             final position = Duration(seconds: value.toInt());
//             await audioPlayer.seek(position);

//             //optional: if audio was paused, changing slider autoplays the audio
//             await audioPlayer.resume();
//           },
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(formatTime(position)),
//               Text(formatTime(duration)),
//             ],
//           ),
//         ),
//         CircleAvatar(
//           radius: 35,
//           child: IconButton(
//             icon: Icon(
//               isPlaying ? Icons.pause : Icons.play_arrow,
//             ),
//             iconSize: 50,
//             onPressed: () async {
//               if (isPlaying) {
//                 await audioPlayer.pause();
//               } else {
//                 await audioPlayer.resume();
//               }
//             },
//           ),
//         )
//       ],
//     );
//   }
// }
