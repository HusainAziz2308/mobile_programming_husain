
import 'package:flutter/material.dart';

import 'counter_display.dart';
import 'counter_buttons.dart';

void main() {
  runApp(const CounterApp());
}

// ROOT APPLICATION
class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  bool _isCounterMounted = true;

  // Mengatur pemasangan dan pelepasan widget counter.
  // Digunakan untuk membuktikan initState dan dispose.
  void _toggleCounter() {
    setState(() {
      _isCounterMounted = !_isCounterMounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF304FFE),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFF3F5FA),
        appBar: AppBar(
          title: const Text(
            'Counter App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              tooltip: _isCounterMounted
                  ? 'Uji dispose'
                  : 'Buka kembali counter',
              onPressed: _toggleCounter,
              icon: Icon(
                _isCounterMounted
                    ? Icons.close
                    : Icons.refresh,
              ),
            ),
          ],
        ),

        body: _isCounterMounted
            ? const CounterPage()
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.power_off_rounded,
                      size: 65,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Widget Counter sedang ditutup',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    FilledButton.icon(
                      onPressed: _toggleCounter,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Buka Kembali Counter'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// HALAMAN COUNTER
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  // WIDGET LIFECYCLE: INIT STATE
  @override
  void initState() {
    super.initState();

    print('Counter dimulai');
  }

  // FUNGSI TAMBAH
  void _tambahCounter() {
    setState(() {
      _counter++;
    });
  }

  // FUNGSI KURANG
  void _kurangCounter() {
    if (_counter <= 0) {
      return;
    }

    setState(() {
      _counter--;
    });
  }

  // FUNGSI RESET
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  // WIDGET LIFECYCLE: DISPOSE
  @override
  void dispose() {
    print('Counter ditutup');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Aplikasi Penghitung Angka',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // PASSING DATA KE COUNTER DISPLAY
            CounterDisplay(
              counter: _counter,
            ),

            const SizedBox(height: 35),

            // PASSING CALLBACK KE COUNTER BUTTONS
            CounterButtons(
              onAdd: _tambahCounter,
              onSubtract: _kurangCounter,
              onReset: _resetCounter,
            ),

            const SizedBox(height: 25),

            const Text(
              'Nilai counter tidak dapat kurang dari 0',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
