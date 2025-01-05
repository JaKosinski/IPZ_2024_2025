import 'package:flutter/material.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn() {
    // TODO logika autoryzacji; narazie tylko przekierowanie do homepage
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage())
    );
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
              'Zaloguj się do aplikacji',
              style: TextStyle(fontSize: 50.0)
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
              child: TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Login',
                ),
                onSubmitted: (value) {
                  // TODO logika przyjmowania loginu
                  print("Login: $value");
                }
              )
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Hasło',
                    ),
                    onSubmitted: (value) {
                      // TODO logika przyjmowania hasła
                      print("Hasło: $value");
                    }
                )
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
          ],
        ),
      ),
    );
  }
}