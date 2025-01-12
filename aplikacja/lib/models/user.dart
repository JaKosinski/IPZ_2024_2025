import '../models/event.dart';

class User {
  final String email;
  final String nickname;
  List<Event> registeredEvents;
  final String profilePicPath;
  final String password; // Hasło (zaszyfrowane)

  User({
    required this.email,
    required this.nickname,
    List<Event>? registeredEvents,
    required this.profilePicPath,
    required this.password,
  }) : registeredEvents = registeredEvents ?? [];

  // Dodanie wydarzenia do listy
  void registerEvent(Event event) {
    if (!registeredEvents.contains(event)) {
      registeredEvents.add(event);
    }
  }

  // Usuwanie wydarzenia z listy
  void unregisterEvent(Event event) {
    registeredEvents.remove(event);
  }

  // Wyświetlanie informacji o użytkowniku
  @override
  String toString() {
    return 'User(email: $email, nickname: $nickname, hasło: $password, events: ${registeredEvents.length})';
  }
}

