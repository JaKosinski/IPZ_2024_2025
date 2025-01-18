import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'settings_page.dart';
import '../database/database_helper.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Tymczasowo na sztywno dane logowania
      final data = await DatabaseHelper.getUser('mail@to.com', '12345678');
      setState(() {
        userData = data;
      });
    } catch (e) {
      print('Błąd podczas pobierania danych użytkownika: $e');
    }
  }

  Future<void> _uploadNewProfilePicture(BuildContext context) async {
    try {
      // Inicjalizuj picker
      final picker = ImagePicker();

      // Wybierz obraz z galerii
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Pobierz katalog docelowy (assets/avatars/)
        final directory = Directory('../../assets/avatars/');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        // Zapisz plik w folderze z nazwą <userId>.png
        final String newPath = '${directory.path}/${widget.userId}.png';
        final File newImage = File(newPath);

        // Skopiuj plik
        await File(pickedFile.path).copy(newImage.path);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zdjęcie profilowe zostało zmienione!')),
        );
      } else {
        // Użytkownik anulował wybór
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie wybrano żadnego zdjęcia.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wystąpił błąd: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pomarańczowe tło
          Container(
            color: Colors.orange,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Column(
            children: [
              const SizedBox(height: 50), // Odstęp od góry
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SettingsPage(userId: '<userId>'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Zdjęcie profilowe
              GestureDetector(
                onTap: () => _uploadNewProfilePicture(context),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('../../assets/avatars/${widget.userId}.jpg'),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // Nazwa użytkownika
              Text(
                userData!['nickName'] ?? 'Nie ustawiono',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Biały kontener z zaokrąglonymi rogami
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Tu pewnie będą eventy które hostuje ten użytkownik czy cus',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
