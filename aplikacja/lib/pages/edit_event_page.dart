import 'package:flutter/material.dart';
import '../models/event.dart';
import '../styles/gradients.dart';

class EditEventPage extends StatelessWidget {
  final Event event;
  final Function(Event) onSave; 

  const EditEventPage({Key? key, required this.event,required this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: event.name);
    final TextEditingController locationController = TextEditingController(text: event.location);
    final TextEditingController typeController = TextEditingController(text: event.type);
     final TextEditingController maxParticipantsController =
        TextEditingController(text: event.maxParticipants.toString());

    return Scaffold(
      appBar: AppBar(title: const Text('Edytuj wydarzenie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nazwa wydarzenia'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Lokalizacja'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Typ'),
            ),
            TextField(
                controller: maxParticipantsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Maksymalna liczba uczestników'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // zapis danych
                _saveChanges(
                  context, 
                  nameController.text, 
                  locationController.text, 
                  typeController.text,
                  int.tryParse(maxParticipantsController.text) ?? -1,
                  );
              },
              child: const Text('Zapisz zmiany'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context, String name, String location, String type, int maxParticipants) {
    //TODO: połączenie się z bazą danych

    final updatedEvent = Event(
      id: event.id, //id pozostaje bez zmian
      name: name,
      location: location,
      type: type,
      startDate: event.startDate, //TODO: zmiana daty
      maxParticipants: maxParticipants,
      registeredParticipants: event.registeredParticipants,
      imagePath: event.imagePath, //?TODO: zmiana obrazu?
      //nazwa organizatora 
    );

    onSave(updatedEvent);

    Navigator.pop(context); // Powrót do poprzedniej strony po zapisaniu
  }
}