import 'package:flutter/material.dart';
import '../models/event.dart';

class CreateEventPage extends StatefulWidget {
  final Function(Event) onEventCreated;

  const CreateEventPage({Key? key, required this.onEventCreated}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _maxParticipantsController = TextEditingController();


  void _submitEvent() {
    if (_formKey.currentState!.validate()) {
      try {
        final maxParticipants = _maxParticipantsController.text.isEmpty
            ? -1
            : int.parse(_maxParticipantsController.text);

        final newEvent = Event(
          // nie wiem jak porządnie dać id, więc będę je tworzył na podstawie czasu
          id: DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          name: _nameController.text,
          location: _locationController.text,
          startDate: _selectedDate,
          maxParticipants: int.parse(_maxParticipantsController.text),
          registeredParticipants: 0,
          imagePath: 'assets/placeholder.jpg',
        );

        widget.onEventCreated(newEvent);
        Navigator.pop(context);
      } catch (e) {
        print("Error przy tworzeniu wydarzenia: $e");
      }
    } else {
      print("Niepoprawny formularz!");
    }
  }

  String _addEventPhoto() {
    // TODO Dodawanie zdjęć, można już na gotowo do bazy
    // zmień też wtedy w _submitEvent() żeby dobrze dodawało imagePath
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj wydarzenie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: _addEventPhoto,
                  child: const Icon(Icons.camera),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nazwa wydarzenia'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Podaj nazwę wydarzenia' : null,
              ),
              TextFormField(
                controller:  _locationController,
                decoration: const InputDecoration(labelText: 'Lokalizacja'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Podaj lokalizację' : null,
              ),
              TextFormField(
                controller: _maxParticipantsController,
                decoration: const InputDecoration(labelText: 'Limit uczestników (pozostaw puste, jeżeli brak)'),
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Podaj liczbę lub pozostaw puste';
                  }
                  return null;
                },
              ),
              // Tutaj submit button, jeżeli dojdą jakieś cechy do Eventu to tylko nad tym
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: const Text('Wybierz datę'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitEvent,
                child: const Text('Dodaj Wydarzenie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}