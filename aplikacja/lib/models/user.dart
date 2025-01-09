import '../models/event.dart';

class User {
  final String email;
  final String nickname;
  List<Event> registeredEvents;
  final String profilePicPath;

  User({
    required this.email,
    required this.nickname,
    List<Event>? registeredEvents,
    required this.profilePicPath,
  }) : registeredEvents = registeredEvents ?? [];
}