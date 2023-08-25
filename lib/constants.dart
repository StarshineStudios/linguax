import 'package:flutter/material.dart';

const mainColor = Color.fromARGB(255, 163, 84, 255);
const mainColorDarker = Color.fromARGB(255, 92, 41, 150);
const mainColorFaded = Color.fromARGB(255, 212, 192, 241);
const darkColor = Color.fromARGB(255, 30, 29, 31);
const secondaryColor = Color.fromARGB(255, 255, 247, 220);

const double defaultRadius = 10;
const generalBox = 'darkModeTutorial';
const double defaultPadding = 5;

class NiceButton extends StatefulWidget {
  final Color color;
  final Color inactiveColor;
  final double borderRadius;
  final double height;
  final Widget child;
  final VoidCallback onPressed;
  final bool active;
  const NiceButton({
    super.key,
    this.color = mainColor,
    this.inactiveColor = mainColorFaded,
    this.borderRadius = defaultRadius,
    this.height = 6,
    this.active = true,
    required this.child,
    required this.onPressed,
  });

  @override
  State<NiceButton> createState() => _NiceButtonState();
}

//https://stackoverflow.com/a/67989242
extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

class _NiceButtonState extends State<NiceButton> {
  double _paddingTop = 0;
  late double _paddingBottom = widget.height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        _paddingTop = widget.height;
        _paddingBottom = 0;
      }),
      onTapUp: (_) => setState(() {
        _paddingTop = 0;
        _paddingBottom = widget.height;

        if (widget.active) {
          widget.onPressed();
        }
      }),
      child: AnimatedContainer(
        padding: EdgeInsets.only(top: _paddingTop),
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 0, 0, 0), //transparent
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: _paddingBottom),
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: widget.active
                ? widget.color.darken()
                : widget.inactiveColor.darken(),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.active ? widget.color : widget.inactiveColor,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NiceButton(
                onPressed: () {},
                child: Text('hi'),
                borderRadius: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
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
    displayLarge: TextStyle(
        fontSize: 72, fontWeight: FontWeight.bold, color: secondaryColor),
    titleLarge: TextStyle(
        fontSize: 36, fontWeight: FontWeight.bold, color: secondaryColor),
    bodyMedium:
        TextStyle(fontSize: 14, fontFamily: 'Nunito', color: secondaryColor),
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
    displayLarge: TextStyle(
        fontSize: 72, fontWeight: FontWeight.bold, color: secondaryColor),
    titleLarge: TextStyle(
        fontSize: 36, fontWeight: FontWeight.bold, color: secondaryColor),
    bodyMedium:
        TextStyle(fontSize: 14, fontFamily: 'Nunito', color: secondaryColor),
  ),
);
