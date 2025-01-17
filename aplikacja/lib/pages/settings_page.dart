import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _showPasswordField = false; // Czy pokazać pole do wpisywania hasła

  Future<void> _deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final password = _passwordController.text.trim();

    if (token == null || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wprowadź hasło')),
      );
      return;
    }

    try {
      // Weryfikacja hasła
      final isPasswordCorrect = await DatabaseHelper.verifyPassword(token, password);
      if (!isPasswordCorrect) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nieprawidłowe hasło')),
        );
        return;
      }

      // Ostrzeżenie przed usunięciem konta
      final shouldDelete = await _showConfirmationDialog(context);
      if (shouldDelete) {
        await DatabaseHelper.deleteAccount(token);
        prefs.remove('token'); // Usuń token z pamięci lokalnej
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konto zostało usunięte')),
        );
        Navigator.pushReplacementNamed(context, '/sign_in'); // Przekierowanie na ekran logowania
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: $e')),
      );
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Potwierdzenie usunięcia konta'),
              content: const Text(
                'Czy na pewno chcesz usunąć swoje konto? Operacji nie można cofnąć.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), // Anuluj
                  child: const Text('Anuluj'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true), // Usuń
                  child: const Text(
                    'Usuń',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Domyślnie zwraca `false`, jeśli użytkownik anulował dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showPasswordField) ...[
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Podaj swoje hasło',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _deleteAccount(context),
                child: const Text('Potwierdź usunięcie konta'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showPasswordField = true; // Pokazuje pole do wpisywania hasła
                  });
                },
                child: const Text('Usuń konto'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
