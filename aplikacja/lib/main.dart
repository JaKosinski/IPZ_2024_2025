import 'package:flutter/material.dart';
import 'pages/sign_in.dart';
import 'models/event.dart';

final List<Event> testEvents = [
  Event(
    id: "0",
    name: "Trening z Pudzianem",
    location: "Szczecin, siłownia ZUT",
    eventType: 'warsztaty',
    startDate: DateTime(2025, 2, 14, 18, 0),
    maxParticipants: -1,
    registeredParticipants: 10,
    imagePath: "assets/pudzian0.jpg",
  ),
  Event(
    id: "1",
    name: "Walka z Pudzianem",
    location: "Blok 12, osiedle Kaliny",
    eventType: 'sport',
    startDate: DateTime(2025, 1, 10, 19, 30),
    maxParticipants: 1,
    registeredParticipants: 0,
    imagePath: "assets/pudzian1.jpg",
  ),
  Event(
    id: "2",
    name: "Przejażdżka z Pudzianem",
    location:"Szczecin, Jezioro Głębokie",
    eventType: 'carmeet',
    startDate: DateTime(2025, 12, 24),
    maxParticipants: 3,
    registeredParticipants: 1,
    imagePath: "assets/pudzian2.jpg",
  ),
  Event(
    id: "3",
    name: "Trening w Fortnite z Pudzianem",
    location: "Dom Pudziana",
    eventType: 'gaming',
    startDate: DateTime(2025, 10, 21),
    maxParticipants: 5,
    registeredParticipants: 2,
    imagePath: "assets/pudzian3.jpg",
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
<<<<<<< HEAD
  }}
=======
  }
}
>>>>>>> 5984cdb4fbab1397226af4d350691df718172fa8
