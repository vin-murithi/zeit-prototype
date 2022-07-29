import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  const Tasks({ Key? key }) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  String page = 'Tasks';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(page)),
    );
  }
}