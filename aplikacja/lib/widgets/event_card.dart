import "package:flutter/material.dart";
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Obrazek, tło
        Image.network(
          event.imagePath,
          fit: BoxFit.cover,
        ),
        // Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                event.location,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "ID: ${event.id}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}