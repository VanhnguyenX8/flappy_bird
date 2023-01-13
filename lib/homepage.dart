import 'dart:async';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

import 'barriers.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0; // day la toa do y cua con chim
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  double barrierXone = 1.8; // khoảng các các barier (Khoảng cách màn hình 2 dv) => Khoảng cách 1.8 là gần 2 màn
  double barrierXtwo = 1.8 + 1.5;
  double barrierXthree = 1.8 + 3;
  bool gameStarted = false;
  int score = 0;
  int highscore = 0;

  @override
  void initState() {
    setState(() {
      birdYaxis = 0;
      time = 0;
      height = 0;
      initialHeight = birdYaxis;
      barrierXone = 1.8;
      barrierXtwo = 1.8 + 1.5;
      barrierXthree = 1.8 + 3;
      gameStarted = false;
      score = 0;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  bool checkLose() {
    if (barrierXone < 0.65 && barrierXone > -0.6) {
      if (birdYaxis < -0.43 || birdYaxis > 0.28) {
        return true;
      }
    }
    if (barrierXtwo < 0.6 && barrierXtwo > -0.6) {
      if (birdYaxis < -0.67 || birdYaxis > 0.05) {
        return true;
      }
    }
    if (barrierXthree < 0.6 && barrierXthree > -0.6) {
      if (birdYaxis < -0.2 || birdYaxis > 0.67) {
        return true;
      }
    }
    return false;
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
        if (barrierXone < -2) {
          score++;
          barrierXone += 4.5;
        } else {
          barrierXone -= 0.04;
        }
        if (barrierXtwo < -2) {
          score++;

          barrierXtwo += 4.5;
        } else {
          barrierXtwo -= 0.04;
        }
        if (barrierXthree < -2) {
          score++;

          barrierXthree += 4.5;
        } else {
          barrierXthree -= 0.04;
        }
      });
      if (birdYaxis > 1.3 || checkLose()) {
        // 1.3 là tọa độ Y của phần Contaner màu Xanh
        timer.cancel();
        _showDialog();
      }
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: const Text(
              "GAME OVER",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Score: $score",
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "PLAY AGAIN",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (score > highscore) {
                    highscore = score;
                  }
                  initState();
                  setState(() {
                    gameHasStarted = false;
                  });
                  Navigator.of(context).pop();
                  
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdYaxis), //từ -1 đến 1: 1 là tọa độ dưới, -1 là tọa độ trên
                      duration: const Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: const MyBird(),
                    ),
                    Container(
                      alignment: const Alignment(0, -0.3),
                      child: gameHasStarted
                          ? const Text("")
                          : const Text("Nhấn Để Chơi",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    AnimatedContainer(
                  alignment: Alignment(barrierXone, 1.1),
                  duration: const Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 200.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXtwo, 1.1),
                  duration: const Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 250.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXthree, 1.1),
                  duration: const Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 100.0,
                  ),
                ),
                // các barrier di chuyển theo tọa đô (x) barrierXone
                // từ phải sang trái với tọa đọ phải là 1, trái là -1
                AnimatedContainer(
                  alignment: Alignment(barrierXone, -1.1),
                  duration: const Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 150.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXtwo, -1.1),
                  duration: const Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 100.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXthree, -1.1),
                  duration: const Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 200.0,
                  ),
                ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("SCORE",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(score.toString(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("BEST",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(highscore.toString(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
