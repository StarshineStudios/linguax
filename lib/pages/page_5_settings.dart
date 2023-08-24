import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../constants.dart';

class PageSettings extends StatelessWidget {
  final Box<dynamic> box;
  const PageSettings({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    var darkMode = box.get('darkMode', defaultValue: false);

    void resetProgress() {
      box.put('1al', false);
      box.put('11', false);
      box.put('12', false);

      box.put('2al', false);
      box.put('21', false);
      box.put('22', false);

      box.put('3al', false);
      box.put('31', false);
      box.put('32', false);
    }

    return Scaffold(
      backgroundColor: darkMode ? darkColor : secondaryColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Settings',
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Dark Mode'),
              Container(
                color: const Color.fromARGB(0, 0, 0, 0),
                child: Switch(
                  value: darkMode,
                  onChanged: (val) {
                    box.put('darkMode', !darkMode);
                  },
                ),
              ),
              ConfirmationButton(
                title: 'Reset All Progress',
                dialog: 'Are you sure you want to reset all progress?',
                onConfirm: resetProgress,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmationButton extends StatefulWidget {
  final String title;
  final String dialog;
  final Function onConfirm;
  const ConfirmationButton({
    super.key,
    required this.title,
    required this.dialog,
    required this.onConfirm,
  });
  @override
  State<ConfirmationButton> createState() => _ConfirmationButtonState();
}

class _ConfirmationButtonState extends State<ConfirmationButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showConfirmationDialog,
      child: Text(
        widget.title,
        style: const TextStyle(color: secondaryColor),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.title),
          content: Text(widget.dialog),
          actions: [
            TextButton(
              onPressed: () {
                // Reset progress and dismiss the dialog
                widget.onConfirm();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
