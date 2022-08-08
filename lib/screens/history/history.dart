import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'package:zeit/screens/history/summary.dart';
import 'package:zeit/screens/history/tasks.dart';
import 'package:zeit/controllers/database.dart';

class HistoryHome extends StatefulWidget {
  const HistoryHome({Key? key}) : super(key: key);

  @override
  State<HistoryHome> createState() => _HistoryHomeState();
}

//add tabs
//add tab controller
//add TabBarView pages as body
class _HistoryHomeState extends State<HistoryHome> {
  late Map historyData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Database().readDatabase().then((value) => {historyData = value});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
            color: kSecondaryColor,
            iconSize: 40,
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: const Text(
            'History',
            style: TextStyle(color: kTextColor),
          ),
          bottom: const TabBar(
              unselectedLabelColor: kTextColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: kTertiaryColor,
              ),
              tabs: [
                Tab(
                  text: 'Summary',
                ),
                Tab(
                  text: 'Tasks',
                )
              ]),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryColor,
              Color.fromARGB(255, 255, 255, 255),
            ],
          )),
          child: const TabBarView(children: [
            Summary(),
            Tasks(),
          ]),
        ),
      ),
    );
  }
}
