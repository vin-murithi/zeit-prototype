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
      // print('raw db: $value');
      sortTaskMap(value);
      value.entries.forEach((e) => taskHistoryList.add({e.key: e.value}));
      setState(() {
        database = taskHistoryList;
      });
    });
    print('task hist list: $taskHistoryList');
    return taskHistoryList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    if (database != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
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
                  sessionCount = taskSessions.length;
                  taskData[taskName] = taskSessions;
                },
              );
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kCardColor,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 100,
                    child: Center(
                      child: ListTile(
                        leading: const Icon(
                          Icons.circle,
                          size: 40,
                          color: Color(0xFFFFFFFF),
                        ),
                        title: Text(
                          taskName,
                          textScaleFactor: 1.5,
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
                  ),
                ),
              );
            }),
      );
    } else {
      return Center(child: Text('data loading'));
    }
  }
}
