import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/ballon.dart';

class BubbleScreen extends StatefulWidget {
  const BubbleScreen({Key? key}) : super(key: key);

  @override
  State<BubbleScreen> createState() => _BubbleScreenState();
}

class _BubbleScreenState extends State<BubbleScreen>
    with WidgetsBindingObserver {
  late Timer timer;
  late Timer colorTimer;
  List<Bubble> bubbles = [];
  Random random = Random();
  late bool color;
  int score = 0;
  late Size size;
  bool start = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startGame();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (timer.isActive) {
        timer.cancel();
      }
      if (colorTimer.isActive) {
        colorTimer.cancel();
      }
    } else if (state == AppLifecycleState.resumed) {
      restartGame();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
    if (colorTimer.isActive) {
      colorTimer.cancel();
    }
  }

  void startGame() {
    color = random.nextBool();
    colorTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (timer.isActive) {
        color = random.nextBool();
        Future.delayed(const Duration(milliseconds: 600), () {
          Fluttertoast.showToast(
              msg: color ? 'Pop red balloons only' : 'Pop blue balloons only',
              gravity: ToastGravity.SNACKBAR,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              backgroundColor: color ? Colors.red : Colors.blue);
        });
      } else {
        timer.cancel();
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      Fluttertoast.showToast(
          msg: color ? 'Pop red balloons only' : 'Pop blue balloons only',
          gravity: ToastGravity.SNACKBAR,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: color ? Colors.red : Colors.blue);
    });
    timer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (timer.isActive) {
        generateBubble();
      } else {
        timer.cancel();
      }
    });

    Future.delayed(const Duration(seconds: 50), () {
      if (colorTimer.isActive) {
        colorTimer.cancel();
      }
    });

    Future.delayed(const Duration(seconds: 60), () {
      if (timer.isActive) {
        timer.cancel();
        Future.delayed(const Duration(seconds: 1), endGame);
      }
    });
  }

  void generateBubble() {
    double left = random.nextDouble() * (size.width - 110);
    bool widgetColor = random.nextBool();

    setState(() {
      bubbles.add(Bubble(
        left: left,
        color: widgetColor,
        pop: pop,
        selectColor: color,
      ));
    });
  }

  void pop(bool bubbleColor) {
    if (bubbleColor == color) {
      score++;
      setState(() {});
    }
  }

  void endGame() {
    setState(() {
      start = true;
      bubbles.clear();
    });
  }

  void restartGame() {
    bubbles.clear();
    score = 0;
    start = false;
    startGame();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: !start
          ? Stack(children: [
              for (int i = 0; i < bubbles.length; i++) bubbles[i],
            ])
          : Center(
              child: Transform.scale(
                  scale: 1.5,
                  child: Text(
                    'You Scored \n $score',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              if (start) {
                restartGame();
              }
            },
            child: Text(start ? 'Restart' : 'Your Score: $score')),
      ),
    );
  }
}
