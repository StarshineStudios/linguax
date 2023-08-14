import 'package:flutter/material.dart';
import 'package:flutter_test2/pages/page_setttings.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/page_path.dart';
import 'pages/page_notes.dart';
import 'pages/page_games.dart';
import 'pages/page_dictionary.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

final List<Widget> _pages = [
  PagePath(),
  PageNotes(),
  PageGames(),
  PageDictionary(),
  PageSettings(),
];

class _FirstPageState extends State<FirstPage> {
  int navBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[navBarIndex],
      bottomNavigationBar: Container(
        height: 75,
        color: const Color.fromARGB(255, 163, 84, 255),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: GNav(
            activeColor: Color.fromARGB(255, 255, 247, 220),
            tabBackgroundColor: Color.fromARGB(255, 92, 41, 150),

            //the icon color btw
            color: Color.fromARGB(255, 255, 247, 220),
            padding: EdgeInsets.all(13),
            gap: 8,
            iconSize: 30,
            onTabChange: (index) {
              setState(() {
                navBarIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Path',
              ),
              GButton(
                icon: Icons.book,
                text: 'Notes',
              ),
              GButton(
                icon: Icons.games,
                text: 'Games',
              ),
              GButton(
                icon: Icons.library_books,
                text: 'Dictionary',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
