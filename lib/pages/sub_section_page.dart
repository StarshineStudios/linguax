import 'package:flutter/material.dart';

class SubSectionPage extends StatelessWidget {
  final String subSectionTitle;
  final String buttonLabel;

  const SubSectionPage(this.subSectionTitle, this.buttonLabel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(buttonLabel),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sub-section: $subSectionTitle'),
            Text('Button: $buttonLabel'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
