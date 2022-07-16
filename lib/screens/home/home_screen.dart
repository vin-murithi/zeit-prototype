import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'package:zeit/components/body.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(child: SingleChildScrollView(child: Body())),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading:  const IconButton(
        icon: Icon(Icons.calendar_month),
        onPressed: null,
        color: kSecondaryColor,
        iconSize: 40,
      ),
      actions: const [IconButton(
        icon: Icon(Icons.settings),
        onPressed: null,
        color: kSecondaryColor,
        iconSize: 40,
      ),],
    );
  }
}