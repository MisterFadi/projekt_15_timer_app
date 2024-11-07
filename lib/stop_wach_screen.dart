import 'dart:async';

import 'package:flutter/material.dart';

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
          const SizedBox(height: 100),
          const Text(
            "Start Stopuhr",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 230),
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
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
