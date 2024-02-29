import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer', // Cambia il titolo dell'app da 'Serious Timer' a 'Timer'
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamController<int> _tickController = StreamController<int>();
  StreamController<Duration> _timeController = StreamController<Duration>();
  StreamSubscription<int>? _tickSubscription;
  Duration? _elapsedTime;
  int _tick = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tickSubscription = _tickController.stream.listen((tick) {
      setState(() {
        _elapsedTime = Duration(seconds: tick);
        _timeController.add(_elapsedTime!);
      });
    });
  }

  @override
  void dispose() {
    _tickController.close();
    _timeController.close();
    _tickSubscription?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _tickController.add(_tick);
        _tick++;
      });
    }
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _pauseTimer();
    _tick = 0;
    _elapsedTime = null;
    _timeController.add(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'), // Cambia il titolo dell'appbar da 'Serious Timer' a 'Timer'
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<Duration>(
                  stream: _timeController.stream,
                  initialData: Duration.zero,
                  builder: (context, snapshot) {
                    final duration = snapshot.data;
                    final hours = duration?.inHours ?? 0;
                    final minutes = duration?.inMinutes.remainder(60) ?? 0;
                    final seconds = duration?.inSeconds.remainder(60) ?? 0;

                    return Text(
                      '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: _pauseTimer,
                  child: Text(
                    'Pause',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
