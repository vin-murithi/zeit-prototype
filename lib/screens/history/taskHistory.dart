import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:zeit/constants.dart';
import 'package:zeit/controllers/database.dart';

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
  String theSelectedDayString = '';
  Map firstEntry = {};
  //Day selected by user on calendar
  DateTime? theSelectedDay;
  //Calendar span
  DateTime? firstEntryDate;
  DateTime? lastEntryDate;
  Map lastEntry = {};
  var entryCount = 0;
  //A list of sessions datetime
  List<DateTime> datesList = [];
  //List of end time of sessions in a selected day
  List<String>? listOfSessions;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List taskSessions;
    widget.taskData.values.toList().isEmpty
        ? taskSessions = []
        : taskSessions = widget.taskData.values.toList().first;

    setState(() {
      if (taskSessions.isEmpty) {
        datesList = [];
      } else {
        for (var i = 0; i < taskSessions.length; i++) {
          datesList.add(DateTime.tryParse(taskSessions[i]['end'])!);
          // print('datelist: $datesList');
        }
        firstEntry = taskSessions[0];
        lastEntry = taskSessions[taskSessions.length - 1];
        firstEntryDate = DateTime.tryParse(firstEntry['end']);
        lastEntryDate = DateTime.tryParse(lastEntry['end']);
        firstEntryDateString =
            DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                .format(firstEntryDate!);
        lastEntryDateString = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
            .format(lastEntryDate!);
        entryCount = widget.taskData.values.toList().first.length;
        taskName = widget.taskData.keys.toList().first;
      }
    });
    print('task sessions: $taskSessions');
  }

  List returnDateList() {
    return datesList;
  }

  //Return the a day's session activity as a list of session stop times.
  List getDaySessionActivity(selectedDay) {
    DateTime selectedDate = DateUtils.dateOnly(selectedDay);
    List<String> tlistOfSessions = [];
    datesList.forEach((element) {
      DateTime sessionDate = DateUtils.dateOnly(element);
      if (sessionDate == selectedDate) {
        String sessionTime = '${element.hour}:${element.minute}';
        tlistOfSessions.add(sessionTime);
      }
    });
    setState(() {
      listOfSessions = tlistOfSessions;
      theSelectedDay = selectedDay;
      entryCount = tlistOfSessions.length;
    });
    print(listOfSessions);
    return tlistOfSessions;
  }

  //Return bottom additional information
  Widget getClickedDateString() {
    DateTime ttheSelectedDay = theSelectedDay ?? DateTime.now();
    theSelectedDayString = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
        .format(ttheSelectedDay);
    if (theSelectedDay != null) {
      return Text('on $theSelectedDayString');
    } else {
      return const Text('');
    }
  }

  //Delete Task
  void showDeleteDialog() async {
    print('delete $taskName');

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Center(
              child: Text('Confirm delete'),
            ),
            backgroundColor: kCardColor,
            content: Center(
              child: Text('Do you want to delete $taskName task?'),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              MaterialButton(
                color: kDanger,
                onPressed: () {
                  deleteTask();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  void deleteTask() async {
    int returnStatus = await Database().deleteTask(taskName);
    if (returnStatus == 1) {
      print('$taskName deleted successfully');
      Navigator.pop(context);
    } else {
      print('Error occured while deleting task');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
          // color: kSecondaryColor,
          iconSize: 40,
        ),
        //title
        centerTitle: true,
        title: Text(
          taskName,
        ),
        //Bottom Section
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Card(
                  elevation: 2,
                  child: TableCalendar(
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (
                        context,
                        day,
                        focusedDay,
                      ) {
                        for (DateTime d in returnDateList()) {
                          if (day.day == d.day &&
                              day.month == d.month &&
                              day.year == d.year) {
                            return Center(
                              child: CircleAvatar(
                                backgroundColor: kSuccess,
                                maxRadius: 19,
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        return null;
                      },
                    ),
                    shouldFillViewport: true,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime.now()
                        .subtract(const Duration(days: (365 * 10))),
                    lastDay:
                        DateTime.now().add(const Duration(days: (365 * 10))),
                    onDaySelected: (selectedDay, focusedDay) {
                      getDaySessionActivity(selectedDay);
                    },
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
                          child: Text('First Worked On | $firstEntryDateString',
                              textScaleFactor: 1.1),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Last Worked On | $lastEntryDateString',
                              textScaleFactor: 1.1),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                '${entryCount / 2}',
                                textScaleFactor: 2,
                              )),
                              const Text('Total Hours Invested'),
                              getClickedDateString(),
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
                            showDeleteDialog();
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
      )),
    );
  }
}
