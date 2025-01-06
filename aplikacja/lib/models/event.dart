class Event {
  final String id;        // Unikalny identyfikator
  final String name;      // Nazwa wydarzenia
  final String location;  // Lokalizacja wydarzenia
  final String imagePath;  // Zdjęcie wizualizujące wydarzenie

  Event({
    required this.id,
    required this.name,
    required this.location,
    required this.imagePath,
  });
}