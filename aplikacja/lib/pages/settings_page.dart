import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

class SettingsPage extends StatefulWidget {
  final String userId;

  const SettingsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? userData;
  final TextEditingController _passwordController = TextEditingController();
  bool _showPasswordField = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Tymczasowo na sztywno dane logowania
      final data = await DatabaseHelper.getUser('mail@to.com', '12345678');
      setState(() {
        userData = data;
      });
    } catch (e) {
      print('Błąd podczas pobierania danych użytkownika: $e');
    }
  }

  // Funkcja usuwania konta
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
      final isPasswordCorrect =
          await DatabaseHelper.verifyPassword(token, password);
      if (!isPasswordCorrect) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nieprawidłowe hasło')),
        );
        return;
      }

      final shouldDelete = await _showConfirmationDialog(context);
      if (shouldDelete) {
        await DatabaseHelper.deleteAccount(token);
        prefs.remove('token');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konto zostało usunięte')),
        );
        Navigator.pushReplacementNamed(context, '/sign_in');
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
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Anuluj'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Usuń',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _showEditDialog(String field, String initialValue) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edytuj $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Nowe $field'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedValue = controller.text.trim();
                if (updatedValue.isNotEmpty) {
                  try {
                    await DatabaseHelper.updateUser(
                      widget.userId,
                      {field: updatedValue}, // Klucz i nowa wartość
                    );
                    Navigator.of(context).pop();
                    _fetchUserData(); // Odśwież dane
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('$field zaktualizowane pomyślnie')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Błąd: $e')),
                    );
                  }
                }
              },
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Ustawienia ogólne'),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              // Obsługa kliknięcia w ustawienia profilu
            },
          ),
          Divider(),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Imię'),
                Text(userData!['imie'] ?? 'Nie ustawiono'),
              ],
            ),
            onTap: () => _showEditDialog('imie', userData!['imie'] ?? ''),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nazwisko'),
                Text(userData!['nazwisko'] ?? 'Nie ustawiono'),
              ],
            ),
            onTap: () =>
                _showEditDialog('nazwisko', userData!['nazwisko'] ?? ''),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nazwa'),
                Text(userData!['nickName'] ?? 'Nie ustawiono'),
              ],
            ),
            onTap: () =>
                _showEditDialog('nickName', userData!['nickName'] ?? ''),
          ),
          Divider(),
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
                  _showPasswordField = true;
                });
              },
              child: const Text('Usuń konto'),
            ),
          ],
        ],
      ),
    );
  }
}
