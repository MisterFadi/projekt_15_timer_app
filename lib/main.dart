import 'package:flutter/material.dart';
import 'package:projekt_15_timer_app/count_down_timer_screen.dart';
import 'package:projekt_15_timer_app/stop_wach_screen.dart';

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
