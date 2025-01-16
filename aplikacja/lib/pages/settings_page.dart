import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Przykładowa akcja (do wypełnienia)
          },
          child: const Text('Pusty przycisk'),
        ),
      ),
    );
  }
}
