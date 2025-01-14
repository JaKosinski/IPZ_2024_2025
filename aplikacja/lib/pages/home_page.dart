import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../pages/filtered_page.dart';
import '../pages/new_event_page.dart';


class HomePage extends StatefulWidget {
  final List<Event> events;


  const HomePage({Key? key, required this.events}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedFromBottomBar = 0;
  TextEditingController _searchController = TextEditingController();
  // List<Event> _filteredEvents = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _filteredEvents = widget.events;
  // }

  /// Funkcja wyszukuje eventy ze słowem kluczowym w nazwie/lokalizacji i otweira filtered page ze znalezionymi wynikami
  /// args:
  ///   String query: hasło kluczowe do wyszukania
  void _filterEvents(String query) {
    final filteredEvents = widget.events
      .where((event) =>
        event.name.toLowerCase().contains(query.toLowerCase()) ||
        event.location.toLowerCase().contains(query.toLowerCase()))
      .toList();

// TODO to powinno być sprawdzane w filtered_page ale tam sie jebie
    if(filteredEvents.isEmpty || query.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              query.isEmpty ? 'Pole wyszukania nie może być puste.' : 'Brak wyników dla tego hasła.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              )
            ],
          );
        }
      );
      _searchController.clear();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredPage(filteredEvents: filteredEvents))
    );
  }

  /// Otwieranie okna dialogowego z wyszukiwaniem
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wyszukiwanie wydarzeń'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Wprowadź nazwę lub lokalizację'
            )
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.cancel)
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _filterEvents(_searchController.text);
              },
              child: const Icon(Icons.search),
            )
          ],
        );
      }
    );
  }

  /// Obsługa NavigationBara na dole ekranu
  /// args:
  ///   int index: wybrany przycisk
  void _onBarTapped(int index) {
    setState(() {
      _selectedFromBottomBar = index;
      switch(_selectedFromBottomBar){
        case 0:
          _showSearchDialog();
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEventPage(
                onEventCreated: (newEvent) {
                  setState(() {
                    widget.events.add(newEvent);
                    // _filteredEvents = widget.events;
                  });
                }
              ),
            ),
          );
          break;
        case 3:
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Filtruj po:'),

                  ]
                );
              },
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
          return EventCard(event: widget.events[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        enableFeedback: false,
        backgroundColor: Colors.black54,
        currentIndex: _selectedFromBottomBar,
        onTap: _onBarTapped,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(  // 0
            icon: Icon(Icons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(  // 1
            icon: Icon(Icons.add),
            label: 'dołącz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt_outlined),
            label: 'filtruj',
          )
        ],
      ),
    );
  }
}