import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../pages/filtered_page.dart';

// TODO: spraw, żeby dało się wrócić z wyszukanych wyników do Strony głównej (nowy page?)


class HomePage extends StatefulWidget {
  final List<Event> events;


  const HomePage({Key? key, required this.events}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedFromBottomBar = 0;
  TextEditingController _searchController = TextEditingController();
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _filteredEvents = widget.events;
  }

  void _filterEvents(String query) {
    final filteredEvents = widget.events
        .where((event) =>
          event.name.toLowerCase().contains(query.toLowerCase()) ||
          event.location.toLowerCase().contains(query.toLowerCase()))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FilteredPage(filteredEvents: filteredEvents))

    );
  }

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

  void _onBarTapped(int index) {
    setState(() {
      _selectedFromBottomBar = index;
      switch(_selectedFromBottomBar){
        case 0:
          _showSearchDialog();
          break;
        case 1:
          // TODO: dołączanie do wydarzenia
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
        itemCount: _filteredEvents.length,
        itemBuilder: (context, index) {
          return EventCard(event: _filteredEvents[index]);
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
        ],
      ),
    );
  }
}