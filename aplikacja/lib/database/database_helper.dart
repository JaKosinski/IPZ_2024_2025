import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static const String host = 'localhost';
  static const int port = 3306;
  static const String user = 'root';
  static const String password = ''; // Dałem bez hasłowy dostęp bo i tak lokalnie
  static const String db = 'projektIPZ'; // Nazwa bazydancych

  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }
  static Future<void> addUser(String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:5000/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      print('Użytkownik zarejestrowany pomyślnie');
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error);
    }
  }

  static Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:5000/login');
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

}
