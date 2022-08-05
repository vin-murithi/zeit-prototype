import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:zeit/constants.dart';

class TaskHistory extends StatefulWidget {
  final Map taskData;
  const TaskHistory(this.taskData, {Key? key}) : super(key: key);

  @override
  State<TaskHistory> createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
  String taskName = 'TaskName';
  String firstEntryDateString = 'loading...';
  String lastEntryDateString = 'loading...';
  Map firstEntry = {};
  DateTime? firstEntryDate;
  DateTime? lastEntryDate;
  Map lastEntry = {};
  var entryCount = 0;
  List<DateTime> datesList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List taskSessions = widget.taskData.values.toList().first;

    setState(() {
      for (var i = 0; i < taskSessions.length; i++) {
        datesList.add(DateTime.tryParse(taskSessions[i]['end'])!);
        print(datesList);
      }
      firstEntry = taskSessions[0];
      lastEntry = taskSessions[taskSessions.length - 1];
      firstEntryDate = DateTime.tryParse(firstEntry['end']);
      lastEntryDate = DateTime.tryParse(lastEntry['end']);
      firstEntryDateString = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
          .format(firstEntryDate!);
      lastEntryDateString = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
          .format(lastEntryDate!);
      entryCount = widget.taskData.values.toList().first.length;
      taskName = widget.taskData.keys.toList().first;
    });
  }

  List returnDateList(day) {
    return datesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        //back btn
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: kSecondaryColor,
          iconSize: 40,
        ),
        //title
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text(
          taskName,
          style: const TextStyle(color: kTextColor),
        ),
        //Bottom Section
      ),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Card(
                    elevation: 2,
                    color: kCardColor,
                    child: TableCalendar(
                      shouldFillViewport: true,
                      focusedDay: DateTime.now(),
                      firstDay: DateTime.now()
                          .subtract(const Duration(days: (365 * 10))),
                      lastDay:
                          DateTime.now().add(const Duration(days: (365 * 10))),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.28,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'First Worked On | $firstEntryDateString',
                                textScaleFactor: 1.1),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Last Worked On | $lastEntryDateString',
                                textScaleFactor: 1.1),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  '${entryCount / 2}',
                                  textScaleFactor: 2,
                                )),
                                const Text('Total Hours Invested'),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 170,
                      child: ButtonTheme(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kDanger,
                              onPrimary: Colors.white,
                            ),
                            onPressed: () {
                              print('Delete Task');
                            },
                            child: const Text(
                              'Delete',
                              textScaleFactor: 1.2,
                            )),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      )),
    );
  }
}
