import 'package:flutter/material.dart';
import 'post_dao.dart';
import 'comment_dao.dart';
import 'app_database.dart';
import 'model.dart'; // Assicurati che questo file contenga le classi Post e Comment
// 'widgets.dart'; // Potrebbe essere necessario aggiornare o rimuovere questo import a seconda di come implementi i widget

void main() {
  runApp(const MyApp());
}

late final AppDatabase
    database; // Utilizziamo questa variabile per accedere al database

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post and Comment App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue, backgroundColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Post and Comment App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDb();
  }

  Future<void> _initializeDb() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    // Qui potresti voler precaricare alcuni dati o eseguire altre operazioni di inizializzazione
  }

  // Aggiungi qui i metodi per aggiungere, visualizzare e gestire post e commenti

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Text(
            'Adatta il corpo per mostrare post e consentire l\'aggiunta di commenti'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Qui potresti voler aggiungere la logica per creare un nuovo post o commento
        },
        tooltip: 'Add Post/Comment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
