import 'package:flutter/material.dart';
import 'main_page.dart';

import 'constants.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().box.initStorage;

  runApp(const MyApp());
}

class StorageService {
  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;

  final GetStorage _box = GetStorage();

  StorageService._();

  GetStorage get box => _box;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GetStorage _data = StorageService().box; // Use the singleton instance

  Map<String, dynamic> realSettings = {};

  Map<String, bool> defaultSettings = {
    'dark mode': true,
  };

  @override
  void initState() {
    realSettings = _data.read('settings') ?? defaultSettings;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
          bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
        ),
      ),
      home: const FirstPage(),
    );
  }
}
