import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void showTimerEndNotification(BuildContext ourContext) {
    showModalBottomSheet(
      context: ourContext,
      backgroundColor:
          Colors.green.shade200, // Hintergrundfarbe des Bottom Sheets
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Abgerundete Ecken oben
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Die Zeit ist um!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Der Countdown ist beendet.",
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Schließt das Modal Bottom Sheet
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  Color iconColor = Colors.yellow;
  bool isCountDown = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          actions: [
            const Expanded(child: SizedBox()),
            const Text(
              "Timer / CountDown - App",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              color: iconColor,
              onPressed: () {
                setState(
                  () {
                    // wenn der Button gedrückt wird, dann wird er rot, wenn wieder gedrückt wird dann Gelb
                    if (iconColor == Colors.yellow && isCountDown) {
                      iconColor = Colors.red;
                      isCountDown = false;
                    } else {
                      iconColor = Colors.yellow;
                      isCountDown = true;
                    }
                    // resetTimer();
                  },
                );
              },
              icon: const Icon(Icons.swap_horiz),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: isCountDown
            ? const CountDownTimerScreen()
            : StopWachScreen(onEnd: showTimerEndNotification),
      ),
    );
  }
}

class CountDownTimerScreen extends StatefulWidget {
  const CountDownTimerScreen({super.key});

  @override
  State<CountDownTimerScreen> createState() => _CountDownTimerScreenState();
}

class _CountDownTimerScreenState extends State<CountDownTimerScreen> {
  final TextEditingController controller = TextEditingController();
  Timer? zeit;
  int sekunden = 0;

  Future<void> startTimer() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    if (zeit != null) {
      zeit!.cancel();
    }
    zeit = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (sekunden > 0) {
            sekunden--;
          } else {
            zeit!.cancel();
          }

          // Hier noch eine Funktion aufrufen, wenn der Timer zuende gelaufen ist.
          //showTimerEndNotification(); // Benachrichtigung anzeigen
        });
      },
    );
  }

  void stopTimer() {
    if (zeit != null) {
      zeit!.cancel();
    }
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      sekunden = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Start Countdown",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 100),
          Text(
            "CountDown Zähler: $sekunden",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 40),
          const Text("Bitte stelle eine beliebe Zeit ein"),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
            child: TextFormField(
              style: const TextStyle(color: Colors.black54),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            sekunden.toString(),
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startTimer,
                child: const Text("Start"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: stopTimer,
                child: const Text("Stop"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: resetTimer,
                child: const Text("Reset"),
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class StopWachScreen extends StatefulWidget {
  const StopWachScreen({super.key, required this.onEnd});

  final void Function(BuildContext context) onEnd;

  @override
  State<StopWachScreen> createState() => _StopWachScreenState();
}

class _StopWachScreenState extends State<StopWachScreen> {
  final TextEditingController controller = TextEditingController();
  Timer? zeit;
  int sekunden = 0;
  bool isCountDown = true;
  Color iconColor = Colors.yellow;

  Future<void> startTimer() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    if (zeit != null) {
      zeit!.cancel();
    }
    zeit = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (isCountDown) {
            if (sekunden > 0) {
              sekunden--;
            } else {
              zeit!.cancel();
            }
          } else {
            sekunden++;
          }
          widget.onEnd(context); // Benachrichtigung anzeigen
        });
      },
    );
  }

  void stopTimer() {
    if (zeit != null) {
      zeit!.cancel();
    }
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      sekunden = isCountDown ? 2 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Start Stopuhr",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 100),
          Text(
            "CountDown Zähler: $sekunden",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 40),
          const Text("Bitte stelle eine beliebe Zeit ein"),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
            child: TextFormField(
              style: const TextStyle(color: Colors.black54),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            sekunden.toString(),
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startTimer,
                child: const Text("Start"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: stopTimer,
                child: const Text("Stop"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: resetTimer,
                child: const Text("Reset"),
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
