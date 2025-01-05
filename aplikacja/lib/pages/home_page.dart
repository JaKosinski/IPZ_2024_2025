import 'package:flutter/material.dart';

// narazie bez state, chce tylko zaszkicować
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strona główna'),
      ),
      body: const Center(
        child: Text(
          'Lorem Ipsum Strona Gówna',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}