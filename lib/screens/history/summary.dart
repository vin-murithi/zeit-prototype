import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  String page = 'Summary';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(page)),
    );
  }
}
