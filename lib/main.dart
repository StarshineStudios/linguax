import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'pages/page_1_path.dart';
import 'pages/page_2_notes.dart';
import 'pages/page_3_games.dart';
import 'pages/page_4_dictionary.dart';
import 'pages/page_5_settings.dart';

const generalBox = 'darkModeTutorial';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(generalBox);
  runApp(const MyApp());
}

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: mainColor,
    onPrimary: Colors.black,
    // Colors that are not relevant to AppBar in LIGHT mode:
    primaryContainer: Colors.grey,
    secondary: Colors.grey,
    secondaryContainer: Colors.grey,
    onSecondary: Colors.grey,
    background: Colors.grey,
    onBackground: Colors.grey,
    surface: Colors.grey,
    onSurface: Colors.grey,
    error: Colors.grey,
    onError: Colors.grey,
  ),
  fontFamily: 'Nunito',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Nunito'),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: mainColor,
    onPrimary: Colors.black,
    // Colors that are not relevant to AppBar in LIGHT mode:
    primaryContainer: Colors.grey,
    secondary: Colors.grey,
    secondaryContainer: Colors.grey,
    onSecondary: Colors.grey,
    background: Colors.grey,
    onBackground: Colors.grey,
    surface: Colors.grey,
    onSurface: Colors.grey,
    error: Colors.grey,
    onError: Colors.grey,
  ),
  fontFamily: 'Nunito',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(generalBox).listenable(),
      builder: (context, box, widget) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: darkTheme,
          theme: lightTheme,
          home: const MainPage(),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int navBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(generalBox).listenable(),
      builder: (context, box, widget) {
        List<Widget> pages = [
          const PagePath(),
          const PageNotes(),
          const PageGames(),
          const PageDictionary(),
          PageSettings(box: box),
        ];
        var darkMode = box.get('darkMode', defaultValue: false);
        return Scaffold(
          body: Container(
            color: darkMode ? Colors.black : Colors.white,
            child: pages[navBarIndex],
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
      },
    );
  }
}
