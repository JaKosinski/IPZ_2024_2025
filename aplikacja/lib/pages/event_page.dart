import 'package:flutter/material.dart';
import '../models/event.dart';
import '../styles/gradients.dart';

// to kiedyś trzeba będzie zmienić na stateful być może jak będziemy chcieli robić dołączanie już
// ja chcę zrobić już wygląd, później nie będzie dużo zmian
class EventPage extends StatelessWidget {
  final Event event;

  const EventPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double photoHeight = 300;

    return Scaffold(
      backgroundColor: Colors.white12,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                // być może tutaj trzeba przemyśleć konstruktor, bo ścieżka jest względem pliku, który inicjalizuje event
                event.imagePath,
                height: photoHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              // pojebie mnie ten gradient
              Container(
                height: photoHeight,
                decoration: BoxDecoration(
                  gradient: AppGradients.eventPageGradient,
                ),
              ),
              // tutaj mamy tekst na zdjeciu
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  event.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight:  FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              event.location,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}