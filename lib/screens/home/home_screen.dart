import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zeit/constants.dart';
import 'package:zeit/controllers/database.dart';
import 'package:zeit/screens/history/history.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String eventTone = 'sessionStart';
  int shortBreak = 1;
  int longbreak = 2;
  int session = 2;
  int time = 2;
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
  List taskList = [
    'Default',
  ];

  //Save new added task
  @override
  void initState() {
    super.initState();
    getTaskList();
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
    Map newTaskMap = {newTask.toString(): []};
    await Database().writeDatabase(newTaskMap).then((value) {
      getTaskList();
    });
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
        setState(() {
          taskList.add(key);
          selectedTask = 0;
        });
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
    void playTone() {
      String soundAssetsPath = 'sounds/';
      final player = AudioPlayer();
      if (eventTone == 'sessionStart') {
        String toneName = '$soundAssetsPath$eventTone.mp3';
        player.play(AssetSource(toneName),
            mode: PlayerMode.lowLatency, volume: 10);
        print('play $toneName');
      }
    }

    //Log session
    void logSession() {
      //taskName
      String taskName = taskList[selectedTask];
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
            'sessionCount': currentSessionCount
          }
        ]
      };
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
          setState(() {
            eventTone == 'sessionEnd';
          });
          playTone();
          //start break if prev period was a session
          if (period == session) {
            setState(() {
              time = shortBreak;
              currentSessionCount += 1;
              sessionOngoing = false;
              isOnBreak = true;
            });
            if (currentSessionCount > 4) {
              print('pomodoro complete');
              setState(() {
                currentSessionCount = 0;
                pomodoroInSession = false;
              });
            }
            logSession();
          } else if (period == shortBreak) {
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
            sessionOngoing = false;
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
        eventTone = 'sessionStart';
      });
      managePomodoro();
      playTone();
    }

    //startbreak
    void startBreak() {
      time = shortBreak;
      setState(() {
        breakOngoing = true;
        eventTone = 'sessionStart';
      });
      managePomodoro();
      playTone();
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
      });
      managePomodoro();
    }

    //Return Buttons conditionally
    Widget getButtons() {
      Widget buttons = const Text('Seems to Be an Error');
      if (!sessionOngoing && !isOnBreak) {
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
                  onPressed: () => {startPomodoro()},
                  child: Text('Start Pomodoro'),
                  style: ElevatedButton.styleFrom(
                    primary: kTertiaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (sessionOngoing && !isOnBreak) {
        buttons = Container(
          height: deviceHeight * 0.28,
          width: deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: deviceWidth * 0.8,
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
                    ElevatedButton(
                      onPressed: () => {cancelPomodoro()},
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        primary: kTertiaryColor,
                        minimumSize: Size(150, 48),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      } else if (breakOngoing) {
        buttons = Container(
          height: deviceHeight * 0.28,
          width: deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: deviceWidth * 0.8,
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
                    ElevatedButton(
                      onPressed: () => {cancelPomodoro()},
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        primary: kTertiaryColor,
                        minimumSize: Size(150, 48),
                      ),
                    ),
                  ],
                ),
              )
            ],
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

    Widget getTaskListWidget() {
      if (taskListDisplayed) {
        return Container(
          height: deviceHeight * 0.07,
          width: deviceWidth * 0.8,
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
                            color: index == selectedTask
                                ? Colors.black
                                : kTextColor,
                          ),
                        ),
                      ),
                    ));
              }),
        );
      } else {
        return Container(
            height: deviceHeight * 0.07,
            width: deviceWidth * 0.8,
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

    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Container(
            color: kPrimaryColor,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //Rest of the UI
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Timer CountDown
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Container(
                            alignment: Alignment.center,
                            height: deviceHeight * 0.45,
                            width: deviceWidth,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Color.fromARGB(255, 218, 218, 218),
                                      spreadRadius: 3)
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: kCountDownDial,
                                radius: 250,
                                child: Text(
                                  '$minutes:$seconds',
                                  style: const TextStyle(
                                    fontSize: 90.0,
                                    color: kTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Session progress
                        Container(
                          alignment: Alignment.center,
                          height: deviceHeight * 0.05,
                          width: deviceWidth,
                          child: Text(
                            '$currentSessionCount of 4',
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                                color: kTextColor),
                          ),
                        ),
                        //TaskList
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: pomodoroInSession ? 0 : 1,
                          child: Row(
                            children: [
                              getTaskListWidget(),
                              Container(
                                width: deviceWidth * 0.2,
                                child: Center(
                                    child: GestureDetector(
                                        onTap: () {
                                          if (!taskListDisplayed) {
                                            saveTask(taskInputFieldValue);
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
                                            child: Icon(Icons.add)))),
                              )
                            ],
                          ),
                        ),
                      ]),
                  //Conditional Buttons
                  getButtons(),
                ],
              ),
            )),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
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
        taskList[selectedTask],
        style: const TextStyle(
          color: kTextColor,
          fontSize: 30,
        ),
      ),
      actions: const [
        IconButton(
          icon: CircleAvatar(
              backgroundColor: kTertiaryColor,
              child: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          onPressed: null,
          color: kTertiaryColor,
          iconSize: 40,
        ),
      ],
    );
  }
}
