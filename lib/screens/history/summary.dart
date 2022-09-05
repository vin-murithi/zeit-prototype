import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:zeit/constants.dart';
import 'package:zeit/controllers/database.dart';

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  String page = 'Summary';
  //Database Variable
  var taskHistoryList = [];
  List? database;
  Map? taskMap;
  Map<String, double> pieChartData = {};
  late var taskCount = 0;
  late var sessionCount = 0;
  late double totalHoursInvested = 0;
  List<Color> pieColorList = [
    const Color(0xFF004C7B),
    const Color(0xFF0092FC),
    const Color(0xFFBBE7FF),
    const Color.fromARGB(255, 48, 71, 77),
    const Color.fromARGB(255, 19, 28, 31),
    const Color.fromARGB(255, 32, 32, 32),
  ];

  //Method to get tasks
  Future<List> loadTasks() async {
    await Database().readDatabase().then((value) {
      value.entries.forEach((e) => taskHistoryList.add({e.key: e.value}));
      setState(() {
        database = taskHistoryList;
      });
    });
    return taskHistoryList;
  }

  //Get top three Tasks to put into pie chart
  void sortPieChartMap(pieMap) {
    // Map<String, int> map = {'one': 10, 'two': 5, 'three': 7, 'four': 0};
    Map<String, double> map = pieMap;
    var mapEntries = map.entries.toList()
      ..sort((b, a) => a.value.compareTo(b.value));

    map
      ..clear()
      ..addEntries(mapEntries);

    var index = 0;
    Map<String, double> topThree = {};
    double others = 0;
    map.forEach((key, value) {
      if (index > 2) {
        others += 1;
      } else {
        topThree[key] = value;
      }
      index += 1;
    });
    topThree['Others'] = others;
    setState(() {
      pieChartData = topThree;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks().then((value) {
      setState(() {
        taskCount = value.length;
      });
      value.forEach((element) {
        taskMap = element;
        taskMap!.forEach((key, value) {
          List taskSessions = value;
          String taskName = key.toString();
          double sessionTime = 0;
          taskSessions.forEach((element) {
            sessionTime += (element['sessionDuration'] / 60);
            totalHoursInvested += (element['sessionDuration'] / 60);
          });
          setState(() {
            pieChartData[taskName] = sessionTime;
            // pieChartData[taskName] = taskHours;
            sessionCount += taskSessions.length;
          });
        });
        //get no of tasks
      });

      sortPieChartMap(pieChartData);
      print('pieChartData: $pieChartData');
    });
  }

  @override
  Widget build(BuildContext context) {
    //taskCount and sessionCount

    if (database != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    elevation: 5,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            '$taskCount',
                            textScaleFactor: 2.5,
                          )),
                          const Text('Total Tasks'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            '${totalHoursInvested.toStringAsFixed(1)}',
                            textScaleFactor: 2.5,
                          )),
                          Text('Total Hours')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Card(
                elevation: 5,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 71, 71, 71),
                          width: 1,
                        ),
                      )),
                      child: const SizedBox(
                          height: 60,
                          child: Center(
                              child: Text(
                            'Top 3 Tasks',
                            textScaleFactor: 1.1,
                          ))),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: PieChart(
                        dataMap: pieChartData,
                        colorList: pieColorList,
                        chartRadius: MediaQuery.of(context).size.width * 0.6,
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesOutside: false,
                        ),
                        legendOptions: const LegendOptions(
                          showLegends: true,
                          legendShape: BoxShape.rectangle,
                          legendTextStyle: TextStyle(
                            fontSize: 18,
                          ),
                          legendPosition: LegendPosition.right,
                          showLegendsInRow: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Center(child: Text(page));
    }
  }
}
