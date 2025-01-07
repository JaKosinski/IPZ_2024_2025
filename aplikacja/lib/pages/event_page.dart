import 'package:flutter/material.dart';
import '../models/event.dart';

// to kiedyś trzeba będzie zmienić na stateful być może jak będziemy chcieli robić dołączanie już
// ja chcę zrobić już wygląd, później nie będzie dużo zmian
class EventPage extends StatelessWidget {
  final Event event;

  const EventPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            // być może tutaj trzeba przemyśleć konstruktor, bo ścieżka jest względem pliku, który inicjalizuje event
            event.imagePath,
            height: 60,
            fit: BoxFit.cover,
          ),
          // skończyłeś na gradiencie baranie
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.transparent,
                ],
              )
            )
          )
        ]
      )
    );
  }
}