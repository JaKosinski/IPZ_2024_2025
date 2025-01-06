import 'package:flutter/material.dart';
import 'pages/sign_in.dart';
import 'models/event.dart';

final List<Event> testEvents = [
  Event(
    id: "0",
    name: "Testowe wydarzenie",
    location: "Szczecin",
    imagePath: "assets/pudzian0.jpg",
  ),
  Event(
    id: "1",
    name: "Imieniny Heleny",
    location: "Dom Heleny",
    imagePath: "assets/pudzian1.jpg",
  ),
  Event(
    id: "2",
    name: "Potańcówka",
    location:"Szczecin, Osiedle Zawadzkiego",
    imagePath: "assets/pudzian2.jpg",
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nazwa aplikacji',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true
      ),
      home: SignInPage(events: testEvents),
    );
  }
}