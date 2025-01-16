import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

class SettingsPage extends StatelessWidget {
  Future<void> _deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      try {
        await DatabaseHelper.deleteAccount(token); // Usuwa konto przez API
        prefs.remove('token'); // Usuwa token z pamięci lokalnej

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konto zostało usunięte.')),
        );

        Navigator.pushReplacementNamed(context, '/sign_in'); // Przekierowanie na stronę logowania
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd podczas usuwania konta: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie znaleziono aktywnej sesji.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _deleteAccount(context), // Dodano funkcjonalność do przycisku
          child: const Text('Usuń konto'),
        ),
      ),
    );
  }
}
