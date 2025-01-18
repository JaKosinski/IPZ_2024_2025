import 'package:Hive/widgets/event_type_grid.dart';
import 'package:Hive/pages/event_page.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../pages/filtered_page.dart';
import '../pages/new_event_page.dart';
import '../pages/profile_page.dart';

class HomePage extends StatefulWidget {
  final List<Event> events;

  const HomePage({super.key, required this.events});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> _events = [];
  int _selectedFromBottomBar = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllEvents(); // Wywołanie funkcji pobierającej dane
  }

  // Pobieranie wydarzeń z bazy
  Future<void> _fetchAllEvents() async {
    try {
      final eventsData = await DatabaseHelper.getAllEvents();
      setState(() {
        _events = eventsData
            .map((eventData) => Event(
                  id: eventData['id'] as String,
                  name: eventData['name'] as String,
                  location: eventData['location'] as String,
                  type: eventData['type'] as String,
                  startDate: DateTime.parse(eventData['start_date'] as String),
                  maxParticipants: eventData['max_participants'] as int,
                  registeredParticipants:
                      eventData['registered_participants'] as int,
                  imagePath: eventData['image'] as String,
                ))
            .toList();
      });
    } catch (e) {
      print('Błąd podczas pobierania danych wydarzeń: $e');
    }
  }

  /// Funkcja wyszukuje eventy ze słowem kluczowym w nazwie/lokalizacji i otweira filtered page ze znalezionymi wynikami
  /// args:
  ///   String query: hasło kluczowe do wyszukania
  void _filterEventsByQuery(String query) {
    query = query.trim(); // Usuń zbędne spacje
    print('Debug: Wartość query po trim = "$query"'); // Debugowanie

    if (query.isEmpty) {
      print('Debug: Pole wyszukiwania jest puste.'); // Debugowanie
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Pole wyszukania nie może być puste.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.cancel, color: Colors.red),
              ),
            ],
          );
        },
      );
      return;
    }

    // Filtracja wydarzeń
    final filteredEvents = widget.events
        .where((event) =>
            event.name.toLowerCase().contains(query.toLowerCase()) ||
            event.location.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filteredEvents.isEmpty) {
      print('Debug: Brak wyników wyszukiwania dla "$query"'); // Debugowanie
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Nie znaleziono żadnych wydarzeń.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.cancel, color: Colors.red),
              ),
            ],
          );
        },
      );
      return;
    }

    print('Debug: Liczba znalezionych wydarzeń = ${filteredEvents.length}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredPage(
          filteredEvents: filteredEvents,
          onUpdate: (updatedEvent) {
            setState(() {
              final index = widget.events
                  .indexWhere((event) => event.id == updatedEvent.id);
              if (index != -1) {
                widget.events[index] = updatedEvent;
              }
            });
          },
        ),
      ),
    );
  }

  void _filterEventsByType(String typeFilter) {
    final filteredEvents = widget.events
        .where((event) =>
            event.type.toLowerCase().contains(typeFilter.toLowerCase()))
        .toList();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FilteredPage(
                  filteredEvents: filteredEvents,
                  onUpdate: (Event) {},
                )) //dodane onUpdate?!
        );
  }

  void _filterEventsByDate(DateTime dateFilter) {
    final filteredEvents = widget.events
        .where((event) =>
            event.startDate.year == dateFilter.year &&
            event.startDate.month == dateFilter.month &&
            event.startDate.day == dateFilter.day)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredPage(
          filteredEvents: filteredEvents,
          onUpdate: (Event) {},
        ), //dodane onUpdate?!
      ),
    );
  }

  /// Otwieranie okna dialogowego z wyszukiwaniem
  void _showSearchDialog({bool onlyLocation = false}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Wyszukiwanie wydarzeń'),
            content: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: onlyLocation
                    ? 'Wprowadź lokalizację'
                    : 'Wprowadź nazwę lub lokalizację',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _searchController.clear();
                  },
                  child: const Icon(Icons.cancel)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print(
                      'Debug: Wartość w polu wyszukiwania: ${_searchController.text}'); // Debugowanie
                  _filterEventsByQuery(_searchController.text);
                  _searchController.clear(); // Wyczyść pole
                },
                child: const Icon(Icons.search),
              ),
            ],
          );
        });
  }

  /// Obsługa NavigationBara na dole ekranu
  /// args:
  ///   int index: wybrany przycisk
  void _onBarTapped(int index) {
    setState(() {
      _selectedFromBottomBar = index;
      switch (_selectedFromBottomBar) {
        case 0:
          _showSearchDialog();
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEventPage(onEventCreated: (newEvent) {
                setState(() {
                  widget.events.add(newEvent);
                  // _filteredEvents = widget.events;
                });
              }),
            ),
          );
          break;
        case 2:
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                const Text(
                  'Filtruj po:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                    title: const Text('Typ wydarzenia'),
                    onTap: () async {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return EventTypeGrid(
                                onEventTypeSelected: (String typeFilter) {
                              _filterEventsByType(typeFilter);
                            });
                          });
                    }),
                ListTile(
                    title: const Text('Data'),
                    onTap: () async {
                      Navigator.pop(context);
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _filterEventsByDate(pickedDate);
                      }
                    }),
                ListTile(
                    title: const Text('Lokalizacja'),
                    onTap: () async {
                      Navigator.pop(context);
                      _showSearchDialog(onlyLocation: true);
                    })
              ]);
            },
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(userId: '14'),
            ),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strona Główna'),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.events.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //przekazujemy onUpdate do aktualizacji
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventPage(
                          event: widget.events[index],
                          onUpdate: (updatedEvent) {
                            setState(() {
                              widget.events[index] = updatedEvent;
                            });
                          })));
            },
            child: EventCard(
                event: widget.events[index],
                onUpdate: (updatedEvent) {
                  setState(() {
                    widget.events[index] = updatedEvent;
                  });
                }),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        // powiem Wam szczerze, że nie wiem co robi połowa z tych właściwości, ale buja z nimi
        elevation: 0,
        enableFeedback: false,
        backgroundColor: Colors.black54, // Ustawienie szarego tła
        currentIndex: _selectedFromBottomBar,
        onTap: _onBarTapped,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        items: const [
          BottomNavigationBarItem(
            // 0
            icon: Icon(Icons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(
            // 1
            icon: Icon(Icons.add),
            label: 'dołącz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt_outlined),
            label: 'filtruj',
          ),
          BottomNavigationBarItem(
            // 3
            icon: Icon(Icons.person),
            label: 'profil',
          ),
        ],
      ),
    );
  }
}
