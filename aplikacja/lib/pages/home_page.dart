import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';

// narazie bez state, chce tylko zaszkicować
class HomePage extends StatelessWidget {
  final List<Event> events;

  const HomePage({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strona Główna'),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(event: events[index]);
        },
      ),
    );
  }
}