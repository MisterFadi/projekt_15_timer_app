import 'dart:async';

import 'package:flutter/material.dart';

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
          const SizedBox(height: 10),
          const Text(
            "Start Countdown",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 50),
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
              // ElevatedButton(
              //   onPressed: resetTimer,
              //   child: const Text("Reset"),
              // ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
