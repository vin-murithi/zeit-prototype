import 'package:flutter/material.dart';

class Neumorphism {
  BoxDecoration neumorphicShadows() {
    double blurRadius = 15;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.grey.shade300,
      shape: BoxShape.rectangle,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 1,
            blurRadius: blurRadius,
            offset: const Offset(4, 4)),
        BoxShadow(
            color: Colors.white,
            spreadRadius: 1,
            blurRadius: blurRadius,
            offset: const Offset(-4, -4)),
      ],
    );
  }
}
