import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import '../models/event.dart';
import 'registration.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Obsługa sesji użytkownika
import 'password_change_page.dart';

class SignInPage extends StatefulWidget {
  final List<Event> events;

  const SignInPage(userData, {Key? key, required this.events}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  Future<void> _signIn() async {
    final email = _loginController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wprowadź email i hasło')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/login'), // Zmień na odpowiedni adres serwera
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final token = json.decode(response.body)['token'];
        saveToken(token); // Zapisywanie tokenu sesji do pamięci urządzenia
        final userData = json.decode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zalogowano pomyślnie')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(events: widget.events),
          ),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nieprawidłowe dane logowania')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd serwera: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd połączenia: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logowanie'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Zaloguj się',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50.0),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
              child: TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Hasło',
                ),
              ),
            ),
            Padding(
  padding: const EdgeInsets.symmetric(vertical: 5.0),
  child: TextButton(
    onPressed: () {
      Navigator.pushNamed(context, '/change_password'); // Przejście do widoku zmiany hasła
    },
    child: const Text(
      'Nie pamiętam hasła',
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.blue,
      ),
    ),
  ),
),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ElevatedButton(
                onPressed: _signIn,
                child: const Text(
                  'Zaloguj',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  'Zarejestruj się',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            

          ],
        ),
      ),
    );
  }
}
