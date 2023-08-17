import 'package:flutter/material.dart';
import 'pages/5_page_setttings.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/1_page_path.dart';
import 'pages/2_page_notes.dart';
import 'pages/3_page_games.dart';
import 'pages/4_page_dictionary.dart';

import 'package:get_storage/get_storage.dart';

import 'constants.dart';
import 'main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState(
      //data: data,
      );
}

class _MainPageState extends State<MainPage> {
  int navBarIndex = 0;
  final GetStorage _data =
      StorageService().box; // Access the singleton instance
  late List<Widget> _pages; // Declare the list

  @override
  void initState() {
    super.initState();

    // Initialize _pages here, after settings is fully initialized
    _pages = [
      const PagePath(),
      const PageNotes(),
      const PageGames(),
      const PageDictionary(),
      const PageSettings(),
    ];

    // Ensure that 'dark mode' is initialized in settings if it's not set
    // if (_data.read('settings') == null) {
    //   _data.write('settings', {'dark mode': false});
    // }
  }

  @override
  Widget build(BuildContext context) {
    //bool isDarkMode = _data.read('settings')['dark mode'];

    return Scaffold(
      body: Container(
        color:
            _data.read('settings')['dark mode'] ? Colors.black : Colors.white,
        child: _pages[navBarIndex],
      ),
      bottomNavigationBar: Container(
        height: 75,
        color: mainColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            activeColor: secondaryColor,
            tabBackgroundColor: mainColorDarker,

            //the icon color btw
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
