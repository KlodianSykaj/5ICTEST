import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dipendente App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        hintColor: Colors.grey[700],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.yellow[50],
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainPage(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.yellow[200]!, Colors.white],
          ),
        ),
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.yellow[800], // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/main');
            },
            child: Text(
              'Entra',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  Future<void> _fetchData(String code) async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.get(Uri.parse('http://localhost/server/index.php?codice=$code'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _response = "Stato: ${jsonData['stato']}\n"
            "Messaggio: ${jsonData['messaggio']}\n"
            "Codice: ${jsonData['codice']}\n"
            "Nome: ${jsonData['nome']}\n"
            "Cognome: ${jsonData['cognome']}\n"
            "Reparto: ${jsonData['reparto']}";
        _isLoading = false;
      });
    } else {
      setState(() {
        _response = 'Errore durante la richiesta';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dati Dipendente'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Inserisci il codice del dipendente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.person),
                fillColor: Colors.yellow[50],
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!_isLoading) {
                  _fetchData(_controller.text);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.yellow[800], // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'Invia Richiesta',
                      style: TextStyle(fontSize: 18.0),
                    ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
