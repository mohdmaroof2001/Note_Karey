import 'package:flutter/material.dart';

class RandomColors {
  Color? colors1;
  Color? colors2;

  Color? colors3;

  Color? colors4;
  Color? colors5;
  RandomColors(
      {required this.colors1,
      required this.colors2,
      required this.colors3,
      required this.colors4,
      required this.colors5});
}

List<RandomColors> randomColors = [
  RandomColors(
    colors1: Colors.pink,
    colors2: Colors.yellow,
    colors3: Colors.blue,
    colors4: Colors.green,
    colors5: Colors.purple,
  )
];
