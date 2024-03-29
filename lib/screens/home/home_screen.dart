import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zeit/constants.dart';
import 'package:zeit/controllers/database.dart';
import 'package:zeit/screens/history/history.dart';
import 'package:zeit/screens/settings/settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:zeit/services/local_notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int shortBreak = kShortBreak;
  int longbreak = kLongBreak;
  int session = kPomodoroSession;
  int time = kPomodoroSession;
  int currentSessionCount = 0;
  DateTime currentSessionStart = DateTime.now();
  bool pomodoroInSession = false;
  bool sessionOngoing = false;
  bool isCancelled = false;
  bool isPaused = false;
  bool isOnBreak = false;
  bool breakOngoing = false;
  bool taskListDisplayed = true;
  String taskInputFieldValue = '';
  int selectedTask = 0;
  List taskList = ['Default Task'];
  String? selectedTaskName;

  //Save new added task
  @override
  void initState() {
    super.initState();
    getTaskList();
    selectedTaskName = taskList[0].toString();
    //Initialize duration values
    var sessionDurationInt = Settings.getValue("key-session-duration", 2);
    var sessionDuration = Settings.getValue("key-session", 25);
    var breakDuration = Settings.getValue("key-break", 5);
    // session = getSessionDuration(sessionDurationInt)['session']!;
    // shortBreak = getSessionDuration(sessionDurationInt)['break']!;
    session = sessionDuration * 60;
    shortBreak = breakDuration * 60;
    time = session;
    print('sessionDuration: $sessionDuration');
    print('breakDuration: $breakDuration');
  }

  //sort Map
  Map sortTaskMap(taskMap) {
    Map map = taskMap;
    var mapEntries = map.entries.toList()
      ..sort((b, a) => a.value.compareTo(b.value));

    map
      ..clear()
      ..addEntries(mapEntries);
    return map;
  }

  void saveTask(newTask) async {
    setState(() {
      taskList.insert(0, newTask);
      selectedTaskName = newTask;
    });
    // Map newTaskMap = {newTask.toString(): []};
    // await Database().writeDatabase(newTaskMap).then((value) {
    //   getTaskList();
    // });
  }

  //Get Task List
  void getTaskList() async {
    await Database().readDatabase().then((value) {
      Map taskListMap = {};
      value.forEach((key, value) {
        taskListMap[key] = value.length;
      });
      taskListMap = sortTaskMap(taskListMap);
      taskList = [];
      taskListMap.forEach((key, value) {
        if (key != 'Default Task') {
          setState(() {
            taskList.add(key);
            selectedTask = 0;
          });
        }
      });
      setState(() {
        taskList.insert(0, 'Default Task');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Screen dimensions
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    //Function for making minutes and seconds.
    final minutes = (time ~/ 60).toString().padLeft(2, '0');
    final seconds = time.remainder(60).toString().padLeft(2, '0');
    //Play tone
    void playTone(tone, {int? event}) async {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/$tone.mp3'));
      if (event == 0) {
        LocalNotifications().showLocalNotification(
          title: 'Session Complete',
          body: 'Tap to Open Zeit',
          payload: 'complete',
        );
      } else if (event == 1) {
        LocalNotifications().showLocalNotification(
          title: 'Break Complete',
          body: 'Tap to Open Zeit',
          payload: 'complete',
        );
      }
    }

    //Log session
    void logSession() {
      //taskName
      // String taskName = taskList[selectedTask];
      String taskName = selectedTaskName!;
      //sessionStart
      DateTime taskSessionStart = currentSessionStart;
      //sessionEnd
      DateTime taskSessionEnd = DateTime.now();
      //Format into JSON
      Map sessionData = {
        taskName: [
          {
            'start': taskSessionStart.toString(),
            'end': taskSessionEnd.toString(),
            'sessionCount': currentSessionCount,
            'sessionDuration': (Settings.getValue("key-session", 25) * 60),
          }
        ]
      };
      print('sessionData: $sessionData');
      //Add Session to database
      Database().writeDatabase(sessionData).then((value) => print('success'));
    }

    //Manage pomodoro session
    void managePomodoro() {
      //create object of Timer class and countdown session
      final period = time;
      Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (time > 0) {
          setState(() {
            time--;
          });
        } else {
          timer.cancel();
          //start break if prev period was a session
          if (period == session) {
            playTone('sessionEnd', event: 0);
            setState(() {
              time = shortBreak;
              currentSessionCount += 1;
              sessionOngoing = false;
              isOnBreak = true;
            });
            logSession();
          } else if (period == shortBreak) {
            playTone('sessionEnd', event: 1);
            if (currentSessionCount == 4) {
              print('pomodoro complete');
              setState(() {
                time = longbreak;
                currentSessionCount = 0;
                pomodoroInSession = false;
              });
            }
            print('break');
            setState(() {
              time = session;
              sessionOngoing = false;
              isOnBreak = false;
              breakOngoing = false;
            });
          }
        }

        if (isCancelled) {
          timer.cancel();
          setState(() {
            time = session;
          });
        }
        if (isPaused) {
          timer.cancel();
          setState(() {
            time = time;
          });
        }
      });
    }

    //Start pomodoro Session
    void startPomodoro() {
      if (currentSessionCount == 0) {
        print('Started a new Session');
        setState(() {
          pomodoroInSession = true;
        });
      }
      if (currentSessionCount == 4) {
        print('Pomodoro Session Complete');
        setState(() {
          currentSessionCount = 0;
        });
      }
      setState(() {
        currentSessionStart = DateTime.now();
        sessionOngoing = true;
        isCancelled = false;
        isOnBreak = false;
        time = session;
      });
      managePomodoro();
      playTone('sessionStart');
    }

    //startbreak
    void startBreak() {
      time = shortBreak;
      setState(() {
        breakOngoing = true;
      });
      managePomodoro();
      playTone('sessionStart');
    }

    //Pause Pomodoro
    void pausePomodoro() {
      setState(() {
        isPaused = true;
        time = time;
      });
    }

    //Resume countdown
    void resumePomodoro() {
      if (isPaused) {
        setState(() {
          isPaused = false;
        });
        managePomodoro();
      }
    }

    //cancel pomodoro session
    void cancelPomodoro() {
      setState(() {
        isCancelled = true;
        time = session;
        currentSessionCount = 0;
        pomodoroInSession = false;
        sessionOngoing = false;
        isOnBreak = false;
        breakOngoing = false;
      });
      managePomodoro();
    }

    //Return Buttons conditionally
    Widget getButtons() {
      Widget buttons = const Text('Seems to Be an Error');
      if (!sessionOngoing && !isOnBreak) {
        buttons = Container(
          // height: deviceHeight * 0.28,
          width: deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: deviceWidth * 0.6,
                child: ElevatedButton(
                  onPressed: () => {startPomodoro()},
                  child: Text(!pomodoroInSession
                      ? 'Start Session'
                      : 'Continue Session'),
                  style: ElevatedButton.styleFrom(
                    primary: kTertiaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (sessionOngoing) {
        buttons = Container(
          height: deviceHeight * 0.28,
          width: deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: deviceWidth * 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          {isPaused ? resumePomodoro() : pausePomodoro()},
                      child: Text(isPaused ? 'Resume' : 'Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kTertiaryColor,
                        minimumSize: Size(150, 48),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: ElevatedButton(
                        onPressed: () => {cancelPomodoro()},
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          primary: kTertiaryColor,
                          minimumSize: Size(150, 48),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      } else if (breakOngoing) {
        buttons = Center(
          child: Container(
            height: deviceHeight * 0.28,
            width: deviceWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  width: deviceWidth * 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            {isPaused ? resumePomodoro() : pausePomodoro()},
                        child: Text(isPaused ? 'Resume' : 'Pause'),
                        style: ElevatedButton.styleFrom(
                          primary: kTertiaryColor,
                          minimumSize: Size(150, 48),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: ElevatedButton(
                          onPressed: () => {cancelPomodoro()},
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            primary: kTertiaryColor,
                            minimumSize: Size(150, 48),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      } else if (isOnBreak && !sessionOngoing) {
        buttons = Container(
          height: deviceHeight * 0.28,
          width: deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: deviceWidth * 0.6,
                child: ElevatedButton(
                  onPressed: () => {startBreak()},
                  child: Text('Take Break'),
                  style: ElevatedButton.styleFrom(
                    primary: kTertiaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return buttons;
    }

    //get dropdown menu with task list
    Widget getDropDown() {
      //taskList
      return Container(
        width: deviceWidth * 0.7,
        decoration: BoxDecoration(
          // border: Border(
          //     bottom:
          //         BorderSide(color: Theme.of(context).primaryColor, width: 3)),
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: DropdownButton<String>(
                isExpanded: true,
                iconSize: 30,
                value: selectedTaskName,
                items: taskList
                    .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                  child: Text(
                                value,
                                textAlign: TextAlign.center,
                              )),
                            ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTaskName = value;
                  });
                  print(value);
                }),
          ),
        ),
      );
    }

    //Get dropdown or tasklistwidget
    Widget getTaskListWidget() {
      Widget scrollList = Container(
        height: deviceHeight * 0.07,
        width: deviceWidth * 0.7,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTask = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        taskList[index],
                        style: TextStyle(
                          fontSize: selectedTask == index ? 25.0 : 23.0,
                          fontWeight: selectedTask == index
                              ? FontWeight.w500
                              : FontWeight.w400,
                          // color: index == selectedTask
                          //     ? Colors.black
                          //     : kTextColor,
                        ),
                      ),
                    ),
                  ));
            }),
      );
      Widget dropDown = getDropDown();
      if (taskListDisplayed) {
        return dropDown;
      } else {
        return Container(
            height: deviceHeight * 0.07,
            width: deviceWidth * 0.7,
            child: TextField(
              onChanged: (text) {
                setState(() {
                  taskInputFieldValue = text;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add new Task',
                hintText: 'Add a new Task',
              ),
            ));
      }
    }

    Widget getCancelButton() {
      return Container(
        // color: Colors.red,
        width: deviceWidth * 0.1,
        child: Center(
            child: GestureDetector(
                onTap: () {
                  //close field and dismiss keyboard
                  setState(() {
                    taskListDisplayed = true;
                  });
                },
                child: const CircleAvatar(
                    backgroundColor: kDanger,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.cancel)))),
      );
    }

    return Scaffold(
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //Rest of the UI
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                //Timer CountDown
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    alignment: Alignment.center,
                    height: deviceHeight * 0.45,
                    width: deviceWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 7,
                              color: Theme.of(context).shadowColor,
                              spreadRadius: 1)
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        radius: deviceHeight * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$minutes:$seconds',
                              style: TextStyle(
                                fontSize: 90.0,
                                fontFamily: 'Orbitron',
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                              ),
                            ),
                            Text(
                              '$currentSessionCount of 4',
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //TaskList
                Container(
                  height: deviceHeight * 0.1,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: pomodoroInSession ? 0 : 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: deviceWidth * 0.15,
                          child: !taskListDisplayed ? getCancelButton() : null,
                        ),
                        Center(
                          child: getTaskListWidget(),
                        ),
                        Container(
                          width: deviceWidth * 0.15,
                          child: Center(
                              child: GestureDetector(
                                  onTap: () {
                                    if (!taskListDisplayed) {
                                      saveTask(taskInputFieldValue.replaceFirst(
                                          taskInputFieldValue[0],
                                          taskInputFieldValue[0]
                                              .toUpperCase()));
                                    }
                                    setState(() {
                                      if (taskListDisplayed) {
                                        taskListDisplayed = false;
                                      } else {
                                        taskListDisplayed = true;
                                      }
                                    });
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: taskListDisplayed
                                          ? kTertiaryColor
                                          : kSuccess,
                                      foregroundColor: Colors.white,
                                      child: Icon(taskListDisplayed
                                          ? Icons.add
                                          : Icons.done)))),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              //Conditional Buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: deviceHeight * 0.3,
                  child: getButtons(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: const CircleAvatar(
            backgroundColor: kTertiaryColor,
            child: Icon(
              Icons.calendar_month,
              color: Colors.white,
            )),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryHome()),
          );
        },
        color: kSecondaryColor,
        iconSize: 40,
      ),
      centerTitle: true,
      title: Text(
        // taskList[selectedTask],
        selectedTaskName!,
        style: const TextStyle(
          // color: kTextColor,
          fontSize: 25,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ).then((value) {
              setState(() {
                var sessionDuration = Settings.getValue("key-session", 25);
                var breakDuration = Settings.getValue("key-break", 5);
                session = sessionDuration * 60;
                shortBreak = breakDuration * 60;
                time = session;
              });
            });
          },
          icon: const CircleAvatar(
              backgroundColor: kTertiaryColor,
              child: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          color: kTertiaryColor,
          iconSize: 40,
        ),
      ],
    );
  }
}
