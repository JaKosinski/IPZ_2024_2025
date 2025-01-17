import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/event.dart';
import '../widgets/event_card.dart'; // jeśli używasz EventCard
import '../models/user.dart';


class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() => _instance;

  User? _currentUser;

  UserManager._internal();

  // Getter do pobierania użytkownika
  User? get currentUser => _currentUser;

  // Setter do ustawiania użytkownika
  void setCurrentUser(User user) {
    _currentUser = user;
  }
}


