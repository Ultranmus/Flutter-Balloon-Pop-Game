import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../audio_service.dart';
import '../constants.dart';

class Bubble extends StatefulWidget {
  final double left;
  final bool color;
  final Function pop;
  final bool selectColor;
  const Bubble(
      {Key? key,
      required this.left,
      required this.color,
      required this.pop,
      required this.selectColor})
      : super(key: key);

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  bool show = false;
  bool visible = true;
  double size = 1;
  double position = 0;
  bool hasBeenTapped = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 90), () {
      setState(() {
        show = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getSize() {
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (timer.isActive) {
        if (mounted) {
          setState(() {
            size = size <= 1 ? 1.5 : 0.6;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return AnimatedPositioned(
      bottom: show ? screenHeight : -200,
      left: widget.left,
      duration: const Duration(seconds: 3), // Adjust the duration as needed.
      child: GestureDetector(
        onTap: () {
          if (widget.selectColor == widget.color) {
            setState(() {
              visible = false;
              getSize();

              if (!hasBeenTapped) {
                AudioService().playSound(Constants.sound);
                widget.pop(widget.color);
                hasBeenTapped = true;

                Future.delayed(const Duration(milliseconds: 200), () {
                  if (timer.isActive) {
                    timer.cancel();
                  }
                });
              } // Set size to 1 to stop the scaling animation.
            });
          }
        },
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Transform.scale(
            scale: visible ? 1.0 : size, // Apply pop effect.
            child: SvgPicture.asset(
              'assets/balloon.svg',
              semanticsLabel: 'balloon',
              height: 200,
              width: 200,
              color: widget.color ? Colors.red : Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
