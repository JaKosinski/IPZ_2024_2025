import "package:flutter/material.dart";
import '../models/event.dart';
import '../pages/event_page.dart';
import '../utils/tools.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final int dateDiffrence;

  EventCard({
    super.key, required this.event
  }) : dateDiffrence = DateTime.now()
          .difference(DateTime(event.startDate.year, event.startDate.month, event.startDate.day))
          .inDays;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventPage(event: event)
          ),
        );
      },
      child: Stack(
      fit: StackFit.expand,
      children: [
        // Obrazek, tło
        Image.asset(
          event.imagePath,
          fit: BoxFit.cover,
        ),
        // Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.9),
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
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                dateDiffrence <= 0 ?
                    'Dzisiaj  |  ${event.location}'
                    : 'Za ${dateDiffrence} dni  |  ${event.location}',
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
    ),
    );
  }
}