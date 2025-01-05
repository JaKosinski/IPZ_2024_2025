import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nazwa aplikacji',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Nazwa apliakcji'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final Map<String, String> _users = {};

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter-=10;
    });
  }

  void _resetCounter(){
    setState(() {
      _counter = 0;
    });
  }

  void _showResetDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potwierdzenie'),
          content: const Text('Czy na pewno chcesz zresetować licznik?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Zamknij dialog
              },
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                _resetCounter(); // Resetuj licznik
                Navigator.of(context).pop(); // Zamknij dialog
              },
              child: const Text('Tak, resetuj'),
            ),
          ],
        );
      },
    );
  }

  void _signIn(){

  }

  
  @override
  Widget build(BuildContext context) {
    String login = "";
    String password = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Wymasowałeś guziczek tyle razy:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Zaloguj się do aplikacji',
              style: TextStyle(
                fontSize: 50.0,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
              child: TextField(
                controller: _textController, // Connect the controlle
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Login',
                ),
                onSubmitted: (value) {
                  login = value;
                  print(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Hasło',
                ),
                onSubmitted: (value) {
                  password = value;
                  print(value);
                }
              )
            ),
            ElevatedButton(
              onPressed: _showResetDialog, 
              child: const Text('Resetuj licznik')
            ),
            ElevatedButton(onPressed: _signIn, child: const Text('Zaloguj'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Wymasuj',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      
    );
  }
}
