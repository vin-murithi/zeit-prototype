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
  List<Color> pieColorList = [
    const Color(0xFF004C7B),
    const Color(0xFF0092FC),
    const Color(0xFF777474),
    const Color(0xFFBBE7FF)
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

  //Get total sessions and hours for all tasks
  void getHoursSessions() {}
  @override
  void initState() {
    // TODO: implement initState
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
          double taskHours = (taskSessions.length / 2);
          setState(() {
            pieChartData[taskName] = taskHours;
            sessionCount += taskSessions.length;
          });
        });
        //get no of tasks
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //taskCount and sessionCount

    if (database != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kCardColor,
                  child: SizedBox(
                    width: 150,
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
                  color: kCardColor,
                  child: SizedBox(
                    width: 150,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          '${sessionCount / 2}',
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
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Card(
              elevation: 5,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: kCardColor,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: PieChart(
                  dataMap: pieChartData,
                  colorList: pieColorList,
                  chartRadius: MediaQuery.of(context).size.width / 2,
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: false,
                    showChartValuesOutside: true,
                  ),
                  legendOptions: const LegendOptions(
                    showLegends: true,
                    legendShape: BoxShape.rectangle,
                    legendTextStyle: TextStyle(
                      fontSize: 18,
                    ),
                    legendPosition: LegendPosition.bottom,
                    showLegendsInRow: true,
                  ),
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Center(child: Text(page));
    }
  }
}
