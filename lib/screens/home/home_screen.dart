import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'package:zeit/components/body.dart';
import 'package:zeit/screens/history/history.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kPrimaryColor,
                Color.fromARGB(255, 255, 255, 255),
              ],
            )),
            child: SingleChildScrollView(child: Body())),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.calendar_month),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryHome()),
          );
        },
        color: kSecondaryColor,
        iconSize: 40,
      ),
      actions: const [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: null,
          color: kSecondaryColor,
          iconSize: 40,
        ),
      ],
    );
  }
}
