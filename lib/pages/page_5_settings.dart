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
      box.delete('1al' 'position');
      box.delete(
        '1al' 'duration',
      );

      box.put('1al' 'finished', false);
      box.put('11' 'finished', false);
      box.put('12' 'finished', false);

      box.put('1al' 'accuracy', 0.0);
      box.put('11' 'accuracy', 0.0);
      box.put('12' 'accuracy', 0.0);
///////////////////////
      box.delete('2al' 'position');
      box.delete('2al' 'duration');
      box.put('2al' 'finished', false);
      box.put('21' 'finished', false);
      box.put('22' 'finished', false);

      box.put('2al' 'accuracy', 0.0);
      box.put('21' 'accuracy', 0.0);
      box.put('22' 'accuracy', 0.0);
///////////////////////\
      box.delete('3al' 'position');
      box.delete('3al' 'duration');
      box.put('3al' 'finished', false);
      box.put('31' 'finished', false);
      box.put('32' 'finished', false);

      box.put('3al' 'accuracy', 0.0);
      box.put('31' 'accuracy', 0.0);
      box.put('32' 'accuracy', 0.0);
    }

    return Scaffold(
      backgroundColor: mainColorBackground,
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
              const Text(
                'Dark Mode',
                style: TextStyle(color: secondaryColor),
              ),
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
          backgroundColor: mainColorBackground,
          title: Text(widget.title),
          content: Text(widget.dialog),
          actions: [
            NiceButton(
              onPressed: () {
                widget.onConfirm();
                Navigator.of(context).pop();
              }, // Allow navigation back
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Text('Yes'),
              ),
            ),
            NiceButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, // Stay on the page
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Text('No'),
              ),
            ),
          ],
        );
      },
    );
  }
}
