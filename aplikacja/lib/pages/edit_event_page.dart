import 'package:flutter/material.dart';
import '../models/event.dart';
import '../styles/gradients.dart';
import '../database/database_helper.dart';

class EditEventPage extends StatefulWidget {
  final Event event;
  final Function(Event) onSave; 

  const EditEventPage({Key? key, required this.event,required this.onSave}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();

}

class _EditEventPageState extends State<EditEventPage>
{
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _typeController;
  late TextEditingController _maxParticipantsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.name);
    _locationController = TextEditingController(text: widget.event.location);
    _typeController = TextEditingController(text: widget.event.type);
    _maxParticipantsController = TextEditingController(
      text: widget.event.maxParticipants.toString(),
    );
  }

  void _saveEvent() async {
    final updatedEvent = Event(
      id: widget.event.id,
      name: _nameController.text,
      location: _locationController.text,
      type: _typeController.text,
      startDate: widget.event.startDate,
      maxParticipants: int.parse(_maxParticipantsController.text),
      registeredParticipants: widget.event.registeredParticipants,
      imagePath: widget.event.imagePath,
    );

    try {
      await DatabaseHelper.updateEvent(widget.event.id, {
        'name': updatedEvent.name,
        'location': updatedEvent.location,
        'type': updatedEvent.type,
        'start_date': updatedEvent.startDate.toIso8601String(),
        'max_participants': updatedEvent.maxParticipants,
        'registered_participants': updatedEvent.registeredParticipants,
        'image': updatedEvent.imagePath,
      });

      widget.onSave(updatedEvent);
      Navigator.pop(context); // Powrót po zapisaniu
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd podczas aktualizacji wydarzenia: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj wydarzenie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nazwa'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lokalizacja'),
            ),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Typ'),
            ),
            TextField(
              controller: _maxParticipantsController,
              decoration: const InputDecoration(labelText: 'Max uczestników'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveEvent,
              child: const Text('Zapisz zmiany'),
            ),
          ],
        ),
      ),
    );
  }

  
}
