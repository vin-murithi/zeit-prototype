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
class _HistoryHomeState extends State<HistoryHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Map historyData;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    Database().readDatabase().then((value) => {historyData = value});
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: TabBar(
                unselectedLabelColor: kTextColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BoxDecoration(
                  color: kTertiaryColor,
                ),
                tabs: const [
                  Tab(
                    text: 'Summary',
                  ),
                  Tab(
                    text: 'Tasks',
                  )
                ],
                controller: tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: const [
                  Summary(),
                  Tasks(),
                ],
                controller: tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
