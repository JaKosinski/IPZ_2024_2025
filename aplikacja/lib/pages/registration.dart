import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Klucz do zarządzania stanem formularza
  final _formKey = GlobalKey<FormState>();

  // Kontrolery tekstu dla nicknameu, e-maila i hasła
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Funkcja do obsługi rejestracji
  void _register() {
  if (_formKey.currentState!.validate()) {
    // TODO: Sprawdź, czy e-mail i nickname są unikalne w bazie danych
    print("Rejestracja udana!");
    print("Nickname: ${_nicknameController.text}");
    print("E-mail: ${_emailController.text}");
    print("Hasło: ${_passwordController.text}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rejestracja udana!, teraz możesz zalogować się do konta'))
    );

    // Wyczyszczenie pól po rejestracji
    _nicknameController.clear();
    _emailController.clear();
    _passwordController.clear();
  } else {
    print("Rejestracja nie powiodła się. Popraw dane.");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejestracja'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Powiązanie formularza z kluczem
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pole tekstowe dla nickname
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // Walidacja nickname
                  if (value == null || value.isEmpty) {
                    return 'Podaj nickname.';
                  }
                  if (value.length < 3) {
                    return 'Nickname musi mieć co najmniej 3 znaki.';
                  }
                  // TODO: Sprawdź, czy nickname jest unikalny w bazie danych
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Pole tekstowe dla e-maila
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  // Walidacja e-maila
                  if (value == null || value.isEmpty) {
                    return 'Podaj e-mail.';
                  }
                  // Sprawdzenie czy e-mail jest poprawny
                  final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Podaj poprawny e-mail.';
                  }
                  return null; // Poprawny e-mail
                },
              ),
              const SizedBox(height: 20),
              // Pole tekstowe dla hasła
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Hasło',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Ukrywanie hasła
                validator: (value) {
                  // Walidacja hasła
                  //sprawdzanie czy haslo jest puste
                  if (value == null || value.isEmpty) {
                    return 'Podaj hasło.';
                  }
                  //walidacja czy hasło ma Jedną wielką litere,jedną małą litere,
                  // conajmniej jedną cyfrę, conajmniej jeden znak specjalny i minimum 8 znaków
                  final passwordRegex = RegExp(
                  r'^([A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$');
                  if(!passwordRegex.hasMatch(value)){
                    return 'Hasło musi zawierać co najmniej 8 znaków, wielką literę, cyfrę i znak specjalny. ';
                  }
                  return null; // Poprawne hasło
                },
              ),
              const SizedBox(height: 20),
              // Przycisk rejestracji
              ElevatedButton(
                onPressed: _register, // Wywołanie rejestracji
                child: const Text('Zarejestruj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
