import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejestracja'),
      ),
      body: Center(
        child: SingleChildScrollView(  // Dodajemy SingleChildScrollView, aby unikać problemów z przewijaniem na małych ekranach
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Zarejestruj się',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),
                
                // Pole do wpisania e-maila
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,  // Umożliwia wprowadzenie adresu e-mail
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Pole do wpisania hasła
                TextField(
                  controller: _passwordController,
                  obscureText: true,  // Ukrywa tekst, aby wprowadzone hasło było widoczne jako kropki
                  decoration: const InputDecoration(
                    labelText: 'Hasło',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Przycisk rejestracji
                ElevatedButton(
                  onPressed: () {
                    // Tu można dodać logikę rejestracji, np. walidację formularza
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    print("E-mail: $email, Hasło: $password");
                  },
                  child: const Text('Zarejestruj'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}