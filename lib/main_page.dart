import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/1_page_path.dart';
import 'pages/2_page_notes.dart';
import 'pages/3_page_games.dart';
import 'pages/4_page_dictionary.dart';
import 'pages/5_page_setttings.dart';
import 'constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int navBarIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const PagePath(),
      const PageNotes(),
      const PageGames(),
      const PageDictionary(),
      const PageSettings(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[navBarIndex],
      bottomNavigationBar: Container(
        height: 75,
        color: mainColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            activeColor: secondaryColor,
            tabBackgroundColor: mainColorDarker,
            color: secondaryColor,
            textStyle: const TextStyle(
              fontFamily: 'Nunito',
              color: secondaryColor,
            ),
            padding: const EdgeInsets.all(13),
            gap: 8,
            iconSize: 30,
            onTabChange: (index) {
              setState(() {
                navBarIndex = index;
              });
            },
            tabs: const [
              GButton(icon: Icons.home, text: 'Path'),
              GButton(icon: Icons.book, text: 'Notes'),
              GButton(icon: Icons.games, text: 'Games'),
              GButton(icon: Icons.library_books, text: 'Dictionary'),
              GButton(icon: Icons.settings, text: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
