import 'package:ballon_game/screens/bubble_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Game());
}

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BubbleScreen(),
    );
  }
}
