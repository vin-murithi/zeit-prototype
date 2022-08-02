import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'package:zeit/controllers/database.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  //Database Variable
  String page = 'No Tasks to display';
  var taskHistoryList = [];
  List? database;

  //Method to get tasks
  Future<List> loadTasks() async {
    await Database().readDatabase().then((value) {
      value.entries.forEach((e) => taskHistoryList.add({e.key: e.value}));
      setState(() {
        database = taskHistoryList;
      });
      // print(taskHistoryList[0].sessions);
    });
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
      return ListView.builder(
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
              },
            );
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.circle,
                    size: 40,
                    color: Color(0xFF777474),
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
                    print(taskSessions);
                  },
                ),
              ),
            );
          });
    } else {
      return Center(child: Text('data loading'));
    }
  }
}
