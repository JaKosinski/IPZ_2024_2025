import 'package:flutter/material.dart';
import '../models/event.dart';
import '../styles/gradients.dart';
import '../pages/edit_event_page.dart';

// to kiedyś trzeba będzie zmienić na stateful być może jak będziemy chcieli robić dołączanie już
// ja chcę zrobić już wygląd, później nie będzie dużo zmian
class EventPage extends StatefulWidget {
  final Event event;
  //final Function(Event) onDelete; // Callback do usuwania wydarzenia
  final Function(Event) onUpdate;

  const EventPage({super.key, required this.event,required this.onUpdate});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>{
  late Event _currentEvent; //aktualne wydarzenie

  @override
  void initState()
  {
    super.initState();
    _currentEvent = widget.event; //inicjuje stan z początkowego wydarzenia
  }

  void _updateEvent(Event updatedEvent)
  {
    setState(() {_currentEvent = updatedEvent;});
  }

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
                _currentEvent.imagePath,
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
                  _currentEvent.name,
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
              '${_currentEvent.location}  |  ${_currentEvent.type}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () => _navigateToEditPage(context),
              child: const Text ('Edytuj wydarzenie')
              )
          )
        ],
      ),
    );
  }

  void _navigateToEditPage(BuildContext context) 
  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(event: _currentEvent, onSave: (updatedEvent) {_updateEvent(updatedEvent);
        widget.onUpdate(updatedEvent);}), // Przekierowanie na stronę edycji
      ),
    );
  }
}