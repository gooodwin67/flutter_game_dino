import 'dart:async';

import 'package:flutter/material.dart';

import 'barier.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var whiteStyle = const TextStyle(color: Colors.white, fontSize: 20);
  bool startGame = false;
  static double dinoYaxis = 1;
  double time = 0;
  double height = 0;
  double initialHeight = dinoYaxis;

  double grad = 0;

  double barierXAxis = 1;

  double damageX1 = -0.52;
  double damageX2 = -0.43;
  double damageY1 = 1;
  double damageY2 = 0.84;

  int score = 0;
  int bestScore = 0;

  void _jump() {
    if (height == 0 && startGame) {
      initialHeight = dinoYaxis;
      Timer.periodic(const Duration(milliseconds: 60), (timer) {
        time += 0.047;
        height = -4.9 * time * time + 2.8 * time;
        setState(() {
          grad += 0.13;
          dinoYaxis = initialHeight - height;
          if (dinoYaxis > 1) {
            timer.cancel();
            dinoYaxis = 1;
            height = 0;
            time = 0;
            grad = 0;
          }
        });
      });
    }
  }

  void _startGame() {
    setState(() {
      startGame = true;
    });

    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      setState(() {
        score = timer.tick;
        barierXAxis -= 0.07;
        if (barierXAxis < -1) {
          barierXAxis = 1.2;
        } else if (barierXAxis > -0.54 &&
            barierXAxis < -0.41 &&
            dinoYaxis > 0.84) {
          timer.cancel();
          bestScore < score ? bestScore = score : bestScore = bestScore;
          score = 0;
          startGame = false;
          barierXAxis = 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: _jump,
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(microseconds: 0),
                        alignment: Alignment(-0.5, dinoYaxis),
                        color: Colors.blue[300],
                        child: Transform.rotate(
                          angle: grad,
                          child: Container(
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(microseconds: 0),
                        alignment: Alignment(barierXAxis, 1),
                        child: const Barier(),
                      ),
                      !startGame
                          ? Container(
                              alignment: const Alignment(0, 0),
                              child: TextButton(
                                  onPressed: _startGame,
                                  child: const Text(
                                    'Start Game',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                            )
                          : const Text(''),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.brown,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Score',
                              style: whiteStyle,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              score.toString(),
                              style: whiteStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Best Score',
                              style: whiteStyle,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              bestScore.toString(),
                              style: whiteStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
