import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static const String link = 'http://192.168.56.1:5000';
  // static const String host = 'localhost';
  // static const int port = 3306;
  // static const String user = 'root';
  // static const String password = ''; // Dałem bez hasłowy dostęp bo i tak lokalnie
  // static const String db = 'projektIPZ'; // Nazwa bazydancych
  //
  // static Future<MySqlConnection> getConnection() async {
  //   final settings = ConnectionSettings(
  //     host: host,
  //     port: port,
  //     user: user,
  //     password: password,
  //     db: db,
  //   );
  //   return await MySqlConnection.connect(settings);
  // }
  static Future<void> addUser(
      String nickname, String email, String password) async {
    final url = Uri.parse('$link/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'nickname': nickname, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      print('Użytkownik zarejestrowany pomyślnie');
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error);
    }
  }

  static Future<Map<String, dynamic>?> getUser(
      String email, String password) async {
    final url = Uri.parse('$link/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user'];
    } else {
      final error = jsonDecode(response.body)['message'];
      throw Exception(error);
    }
  }

  static Future<void> updateUser(
      String userId, Map<String, String> updatedFields) async {
    print('URL: $link/update_user/$userId');
    print('Dane do aktualizacji: ${jsonEncode(updatedFields)}');
    final url = Uri.parse('$link/update_user/$userId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedFields), // Dane do aktualizacji
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['message'] ??
          'Błąd podczas aktualizacji danych użytkownika';
      throw Exception(error);
    }
  }

  static Future<void> verifyToken(String token) async {
    final url = Uri.parse(
        '$link/verify_token'); // Zakładając, że endpoint to '/verify_token'
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Token jest ważny
      print('Token jest ważny');
    } else {
      // Token jest nieważny
      print('Token jest nieważny');
      throw Exception(
          'Token jest nieważny'); // Możesz obsłużyć błąd w inny sposób
    }
  }

  // Dodawanie wydarzeń
  static Future<void> addEvent(Map<String, dynamic> eventData) async {
    final url = Uri.parse('$link/events');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 201) {
      print('Wydarzenie dodane pomyślnie');
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error);
    }
  }

  // Aktualizowanie wydarzeń
  static Future<void> updateEvent(
      String id, Map<String, dynamic> eventData) async {
    final url = Uri.parse('$link/events/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(eventData),
    );

    if (response.statusCode == 200) {
      print('Wydarzenie zaktualizowane pomyślnie');
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error);
    }
  }

  // Usuwanie wydarzeń
  static Future<void> deleteEvent(String id) async {
    final url = Uri.parse('$link/events/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Wydarzenie usunięte pomyślnie');
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error);
    }
  }

  // Pobieranie wydarzenia
  static Future<Map<String, dynamic>?> getEvent(String id) async {
    final url = Uri.parse('$link/events/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['event'];
    } else {
      final error = jsonDecode(response.body)['message'];
      throw Exception(error);
    }
  }

  // Pobieranie wszystkich wydarzeń
  static Future<List<Map<String, dynamic>>> getAllEvents(
      [String? userId]) async {
    var url = Uri.parse('$link/events');

    if (userId != null) {
      url = url.replace(queryParameters: {'userId': userId});
    }

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } else {
      final error = jsonDecode(response.body)['message'];
      throw Exception(error);
    }
  }

  static Future<void> deleteAccount(String token) async {
    final url = Uri.parse('$link/delete_account');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print('Konto zostało usunięte');
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error);
    }
  }

  static Future<bool> verifyPassword(String token, String password) async {
    final url = Uri.parse('$link/verify_password');
    print(token);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'password': password}),
    );

    if (response.statusCode == 200) {
      return true; // Hasło jest poprawne
    } else if (response.statusCode == 401) {
      return false; // Nieprawidłowe hasło
    } else {
      throw Exception('Błąd serwera: ${response.statusCode}');
    }
  }
}
