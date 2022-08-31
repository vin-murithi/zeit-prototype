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
    loadTasks();
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

              taskMap.forEach(
                (key, value) {
                  taskName = key;
                  taskSessions = value;
                  sessionCount = taskSessions.isEmpty ? 0 : taskSessions.length;
                  taskData[taskName] = taskSessions.isEmpty ? {} : taskSessions;
                },
              );
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                          width: 0.5,
                          color: Theme.of(context).textTheme.bodyText2!.color!),
                      // top: BorderSide(
                      //     width: 0.5,
                      //     color: Theme.of(context).textTheme.bodyText2!.color!),
                    ),
                    // borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
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
                      '| ${sessionCount / 2} hours',
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
                ),
              );
            }),
      );
    } else {
      return const Center(child: Text('data loading'));
    }
  }
}
