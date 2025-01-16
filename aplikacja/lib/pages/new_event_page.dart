import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Baza danych
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/event.dart';
import '../widgets/event_type_grid.dart';
import 'dart:io';

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
  String? _selectedEventType;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _maxParticipantsController = TextEditingController();
  String? _imagePath = 'assets/placeholder.jpg';
  final ImagePicker _picker = ImagePicker();

  // TODO zastąp to zapisem na dysk/do bazy danych
  // funkcja zapisująca zdjęcie wydarzenia w telefonie
  // jest tylko i wyłącznie do debugu, to nie może trafić do produkcji
  // ta funkcja jest dosyć syfiasta, uważajcie z używaniem jej
  Future<String?> saveImageLocaly(XFile? image) async {
    try {
      if (image != null) {
        // ścieżka do roota aplikacji
        final directory = await getExternalStorageDirectory();
        print(directory);

        // ścieżka zapisu obrazu
        final String filePath = '${directory!.path}/assets/${image.name}';
        print(filePath);

        final File imageFile = File(image.path);
        await imageFile.copy(filePath);

        return filePath;
      }
    } catch (e) {
      print("Błąd podczas zapisu obrazu: $e");
      return null;
    }
  }

  Future<void> _submitEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        // tworzymy mapę z danymi wydarzenia
        final eventData = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': _nameController.text,
          'location': _locationController.text,
          'type': _selectedEventType ?? 'Brak typu', // upewniamy się, że typ jest ustawiony
          'start_date': _selectedDate.toIso8601String(), // formatujemy datę do ISO 8601
          'max_participants': _maxParticipantsController.text.isEmpty
              ? -1
              : int.parse(_maxParticipantsController.text),
          'registered_participants': 0,
          'image': _imagePath ?? 'assets/placeholder.jpg',
        };

        // zapisujemy dane do bazy
        await DatabaseHelper.addEvent(eventData);

        // wyświetlamy komunikat o powodzeniu
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wydarzenie dodane pomyślnie!')),
        );

        // czyścimy formularz
        _nameController.clear();
        _locationController.clear();
        _maxParticipantsController.clear();
        setState(() {
          _imagePath = 'assets/placeholder.jpg'; // resetujemy zdjęcie
          _selectedEventType = null; // resetujemy typ wydarzenia
        });
      } catch (e) {
        print("Error przy dodawaniu wydarzenia: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd dodawania wydarzenia: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Niepoprawny formularz'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  // TODO no nie zmienia zdjęcia, nie wiem czy tu jest problem czy dalej z zapisywaniem pamiętaj o tym
  Future<void> _addEventPhoto() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Wybierz z galerii'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final String? savedPath = await saveImageLocaly(image);
                  if (savedPath != null) {
                    setState(() {
                      _imagePath = savedPath;
                    });
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Zrób zdjęcie'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  final String? savedPath = await saveImageLocaly(image);
                  if (savedPath != null) {
                    setState(() {
                      _imagePath = image.path;
                    });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _openEventTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EventTypeGrid(
          onEventTypeSelected: (String eventType) {
            setState(() {
              _selectedEventType = eventType;
            });
            Navigator.pop(context);
          },
        );
      },
    );
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
              GestureDetector(
                onTap: _addEventPhoto,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child:  Image.asset(
                    _imagePath!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                ),
              ),
              ElevatedButton(
                  onPressed: () => _openEventTypeSelector(context),
                  child: const Icon(Icons.apps),
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