import 'package:flutter/material.dart';
import 'pages/sign_in.dart';
import 'models/event.dart';

List<Event> testEvents = [
  Event(
    id: "0",
    name: "Trening z Pudzianem",
    location: "Szczecin, siłownia ZUT",
    type: 'Warsztaty',
    startDate: DateTime(2025, 2, 14, 18, 0),
    maxParticipants: -1,
    registeredParticipants: 10,
    imagePath: "assets/pudzian0.jpg",
  ),
  Event(
    id: "1",
    name: "Walka z Pudzianem",
    location: "Blok 12, osiedle Kaliny",
    type: 'Sportowe',
    startDate: DateTime(2025, 1, 29, 19, 30),
    maxParticipants: 1,
    registeredParticipants: 0,
    imagePath: "assets/pudzian1.jpg",
  ),
  Event(
    id: "2",
    name: "Przejażdżka z Pudzianem",
    location:"Szczecin, Jezioro Głębokie",
    type: 'Motoryzacyjne',
    startDate: DateTime(2025, 1, 21),
    maxParticipants: 3,
    registeredParticipants: 1,
    imagePath: "assets/pudzian2.jpg",
  ),
  Event(
    id: "3",
    name: "Trening w Fortnite z Pudzianem",
    location: "Dom Pudziana",
    type: 'Gaming',
    startDate: DateTime(2025, 1, 31),
    maxParticipants: 5,
    registeredParticipants: 2,
    imagePath: "assets/pudzian3.jpg",
  ),
  Event(
    id: "4",
    name: "Montaż gazu w Lamborghini",
    location: "Szczecin, ul. Santocka",
    type: "Motoryzacyjne",
    startDate: DateTime(2025, 1, 31),
    maxParticipants: -1,
    registeredParticipants: 0,
    imagePath: "assets/pudzian4.jpg",
  )
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
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      home: SignInPage(events: testEvents),
    );
  }
}