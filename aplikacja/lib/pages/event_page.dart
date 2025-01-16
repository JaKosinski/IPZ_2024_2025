import 'package:flutter/material.dart';
import '../models/event.dart';
import '../styles/gradients.dart';
import '../pages/edit_event_page.dart';

// to kiedyś trzeba będzie zmienić na stateful być może jak będziemy chcieli robić dołączanie już
// ja chcę zrobić już wygląd, później nie będzie dużo zmian
class EventPage extends StatefulWidget {
  final Event event;
  final Function(Event) onDelete; // Callback do usuwania wydarzenia
  final Function(Event) onUpdate;

  const EventPage({Key? key, required this.event,required this.onUpdate, required this.onDelete}) : super(key: key);

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


  void _deleteEvent() {
    widget.onDelete(_currentEvent);
    Navigator.pop(context); // Wracamy do poprzedniej strony
  }

  void _joinEvent()
  {
    if(_currentEvent.registeredParticipants < _currentEvent.maxParticipants)
    {
      setState(() {
        _currentEvent.registeredParticipants++;
      });
      widget.onUpdate(_currentEvent);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text('Dołączono do wydarzenia: ${_currentEvent.name}')),
        );
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Brak miejsc w wydarzeniu: ${_currentEvent.name}')),
        );
    }
  }

  void _leaveEvent()
  {
    if(_currentEvent.registeredParticipants > 0)
    {
      setState(() {
        _currentEvent.registeredParticipants--;
      });
      widget.onUpdate(_currentEvent);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wypisano z wydarzenia: ${_currentEvent.name}')),
      );
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie można wypisać się z wydarzenia: ${_currentEvent.name}, ponieważ nie jesteś zapisany.')),

      );
    }
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
                 Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst); // Powrót do strony głównej
                    },
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
            child: Text(
              'Zapisanych uczestników: ${_currentEvent.registeredParticipants}/${_currentEvent.maxParticipants}',
              style: const TextStyle(fontSize:16),
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(16),
            ),
            child: Padding(padding: 
            const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(onPressed: _joinEvent,
                icon: const Icon(Icons.add_circle),
                label: const Text('Dołącz do wydarzenia'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity,48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                ),
                ),
                const SizedBox(height: 10),
                if(_currentEvent.registeredParticipants > 0)
                  ElevatedButton.icon(onPressed: _leaveEvent, icon: const Icon(Icons.remove_circle),
                  label: const Text('Wypisz się z wydarzenia'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity,48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),

                    ),

                  ),

                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToEditPage(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edytuj wydarzenie'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _deleteEvent,
                    icon: const Icon(Icons.delete),
                    label: const Text('Usuń wydarzenie'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
              ],
            ))
          ),)

          
          
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