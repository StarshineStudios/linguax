import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

class PageSettings extends StatelessWidget {
  final Box<dynamic> box;
  const PageSettings({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    var darkMode = box.get('darkMode', defaultValue: false);

    void resetProgress() {
      box.put('11', false);
      box.put('12', false);
      box.put('21', false);
      box.put('22', false);
    }

    return Center(
      child: Column(
        children: [
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
    );
  }
}

class ConfirmationButton extends StatefulWidget {
  final String title;
  final String dialog;
  final Function onConfirm;
  ConfirmationButton({
    super.key,
    required this.title,
    required this.dialog,
    required this.onConfirm,
  });
  @override
  _ConfirmationButtonState createState() => _ConfirmationButtonState();
}

class _ConfirmationButtonState extends State<ConfirmationButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showConfirmationDialog,
      child: Text(widget.title),
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
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Reset progress and dismiss the dialog
                widget.onConfirm();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
