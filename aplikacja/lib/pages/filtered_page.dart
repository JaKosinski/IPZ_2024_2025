import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_card.dart'; // jeśli używasz EventCard

class FilteredPage extends StatelessWidget {
  final List<Event> filteredEvents;
  final Function(Event) onUpdate; // funkcja do aktualizacji wydarzeń

  const FilteredPage({Key? key, required this.filteredEvents,required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyniki wyszukiwania'),
      ),
      body: filteredEvents.isEmpty
          ? const Center(
        child: Text(
          'Brak wyników',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      )
          : PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          return EventCard(event: filteredEvents[index], onUpdate: onUpdate,);
        },
      ),
    );
  }
}
