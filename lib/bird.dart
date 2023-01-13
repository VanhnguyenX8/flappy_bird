import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: 60,
      height: 60,
        child: const Image(image: AssetImage('assets/images/bird.png')));
  }
}
