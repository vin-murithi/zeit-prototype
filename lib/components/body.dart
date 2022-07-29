import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'dart:async';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int shortBreak = 2;
  int longbreak = 3;
  int session = 4;
  int time = 4;
  int currentSessionCount = 0;
  DateTime currentSessionStart = DateTime.now();
  bool pomodoroInSession = false;
  bool sessionOngoing = false;
  bool isCancelled = false;
  bool isPaused = false;
  bool isOnBreak = false;
  bool breakOngoing = false;

  //Tasklist Options
  List<String> taskList = [
    'Default',
    'Piano',
    'Study',
    'Design',
    'German',
    'Soccer',
    'Sound Design'
  ];
  int selectedTask = 0;

  @override
  Widget build(BuildContext context) {
    //Screen dimensions
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    //Function for making minutes and seconds.
    final minutes = (time ~/ 60).toString().padLeft(2, '0');
    final seconds = time.remainder(60).toString().padLeft(2, '0');
    //Log session
    void logSession() {
      //taskName
      String taskName = taskList[selectedTask];
      //sessionStart
      DateTime taskSessionStart = currentSessionStart;
      //sessionEnd
      DateTime taskSessionEnd = DateTime.now();
      //Format into JSON
      var sessionData = {
        'task': taskName,
        'start': taskSessionStart,
        'end': taskSessionEnd,
        'sessionCount': currentSessionCount
      };
      //Print
      print(sessionData);
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
            setState(() {
              time = shortBreak;
              currentSessionCount += 1;
              sessionOngoing = false;
              isOnBreak = true;
            });
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
        print('Started a new Sesstion');
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
    }

    //startbreak
    void startBreak() {
      time = shortBreak;
      setState(() {
        breakOngoing = true;
      });
      managePomodoro();
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
          height: deviceHeight * 0.3,
          width: deviceWidth,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimaryColor, Colors.white])),
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
          height: deviceHeight * 0.3,
          width: deviceWidth,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimaryColor, Colors.white])),
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
          height: deviceHeight * 0.3,
          width: deviceWidth,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimaryColor, Colors.white])),
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
          height: deviceHeight * 0.3,
          width: deviceWidth,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimaryColor, Colors.white])),
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

    //Body Widget tree
    return Column(
      children: <Widget>[
        //Current Task
        Container(
          height: deviceHeight * 0.08,
          color: kPrimaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  taskList[selectedTask],
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
        //Rest of the UI
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //Timer CountDown
          Container(
            alignment: Alignment.center,
            height: deviceHeight * 0.35,
            width: deviceWidth,
            color: kPrimaryColor,
            child: CircleAvatar(
              backgroundColor: kCountDownDial,
              radius: 250,
              child: Text(
                '$minutes:$seconds',
                style: TextStyle(fontSize: 70.0, color: kTextColor),
              ),
            ),
          ),
          //Session progress
          Container(
            alignment: Alignment.center,
            height: deviceHeight * 0.10,
            width: deviceWidth,
            color: kPrimaryColor,
            child: Text(
              '$currentSessionCount of 4',
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          //TaskList
          Container(
            height: deviceHeight * 0.07,
            width: deviceWidth,
            color: kPrimaryColor,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: pomodoroInSession ? 0 : 1,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Text(
                            taskList[index],
                            style: TextStyle(
                              fontSize: selectedTask == index ? 27.0 : 25.0,
                              fontWeight: selectedTask == index
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: index == selectedTask
                                  ? Colors.black
                                  : kTextColor,
                            ),
                          ),
                        ));
                  }),
            ),
          ),
        ]),
        //Conditional Buttons
        getButtons(),
      ],
    );
  }
}
