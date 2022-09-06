import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'package:zeit/controllers/database.dart';
import 'package:zeit/screens/history/taskHistory.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  //Database Variable
  String page = 'No Tasks to display';
  Map taskData = {};
  Map taskAndDuration = {};
  var taskHistoryList = [];
  List? database;

  //sort Map
  Map sortTaskMap(taskMap) {
    Map map = taskMap;
    var mapEntries = map.entries.toList()
      ..sort((b, a) => a.value.length.compareTo(b.value.length));

    map
      ..clear()
      ..addEntries(mapEntries);
    return map;
  }

  //Method to get tasks
  Future<List> loadTasks() async {
    await Database().readDatabase().then((value) {
      sortTaskMap(value);
      value.entries.forEach((e) => taskHistoryList.add({e.key: e.value}));
      setState(() {
        database = taskHistoryList;
      });
    });
    return taskHistoryList;
  }

  @override
  void initState() {
    super.initState();
    loadTasks().then((value) {
      value.forEach((element) {
        Map taskMap = element;
        taskMap.forEach((key, value) {
          List taskSessions = value;
          taskSessions.forEach((element) {
            taskAndDuration[key] = (element['sessionDuration'] / 3600);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (database != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
        child: ListView.builder(
            itemCount: taskHistoryList.length,
            itemBuilder: (BuildContext context, int index) {
              Map taskMap = taskHistoryList[index];
              late String taskName;
              late List taskSessions;
              late int sessionCount;
              late double totalHours = 0.0;

              taskMap.forEach(
                (key, value) {
                  taskName = key;
                  taskSessions = value;
                  taskSessions.forEach((element) {
                    totalHours += (element['sessionDuration'] / 3600);
                  });
                  sessionCount = taskSessions.isEmpty ? 0 : taskSessions.length;
                  taskData[taskName] = taskSessions.isEmpty ? {} : taskSessions;
                },
              );
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.task,
                    size: 30,
                  ),
                  title: Text(
                    taskName,
                    textScaleFactor: 1.3,
                  ),
                  trailing: Text(
                    '| ${totalHours.toStringAsFixed(1)} hours',
                    textScaleFactor: 1.2,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskHistory(taskMap)),
                    );
                  },
                ),
              );
            }),
      );
    } else {
      return const Center(child: Text('data loading'));
    }
  }
}
