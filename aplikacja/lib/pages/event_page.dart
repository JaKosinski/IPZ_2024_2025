import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/event.dart';
import '../styles/gradients.dart';
import '../pages/edit_event_page.dart';


// to kiedyś trzeba będzie zmienić na stateful być może jak będziemy chcieli robić dołączanie już
// ja chcę zrobić już wygląd, później nie będzie dużo zmian
class EventPage extends StatefulWidget {
  final Event event;
  //final Function(Event) onDelete; // Callback do usuwania wydarzenia
  final Function(Event) onUpdate;

  const EventPage({Key? key, required this.event,required this.onUpdate}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}


class _EventPageState extends State<EventPage>{


  late Event _currentEvent; //aktualne wydarzenie

  @override
  void initState() {
    super.initState();
    _fetchEventData(); // Pobieramy dane z bazy
  }

  Future<void> _fetchEventData() async {
    try {
      final eventData = await DatabaseHelper.getEvent(widget.event as String); // Pobieramy dane z bazy
      if (eventData != null) {
        setState(() {
          _currentEvent = Event(
            id: eventData['id'],
            name: eventData['name'],
            location: eventData['location'],
            type: eventData['type'],
            startDate: DateTime.parse(eventData['start_date']), // Parsujemy datę z ISO 8601
            maxParticipants: eventData['max_participants'],
            registeredParticipants: eventData['registered_participants'],
            imagePath: eventData['image'],
          );
        });
      } else {
        // Obsłuż przypadek, gdy wydarzenie nie zostało znalezione
        print('Nie znaleziono wydarzenia o podanym ID');
      }
    } catch (e) {
      print('Błąd podczas pobierania danych wydarzenia: $e');
    }
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