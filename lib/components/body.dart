import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'dart:async';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int time = 5;
  bool sessionOngoing = false;


  @override
  Widget build(BuildContext context) {
    //for tasks
    List<String> tasks = ["Study", "Piano", "Gym"];
    double deviceHeight = MediaQuery.of(context).size.height;
    //for countdown
    double deviceWidth = MediaQuery.of(context).size.width;
    //For TaskList
    List<String> taskList = [
      'Piano',
      'Study',
      'Design',
      'Task 1',
      'Task 2',
      'Task 3'
    ];
    int selectedIndex = 0;

    Widget taskListBuilder(int index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Container(
          child: Text(
            taskList[index],
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }

    //For buttons
    //Methods for Pomodoro
    //Stop timer method
    void stopPomodoro([timer]) {
      timer.cancel();
      print('Timer Cancelled');
    }

    //Start pomodoro method
    void startPomodoro() {
      //create object of Timer class and countdown session
      Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (time > 0) {
          setState(() {
            sessionOngoing = true;
            time--;
          });
          print('This is the rem seconds $time');
        } else {
          setState(() {
          sessionOngoing = false; 
          });
          print('$time seconds is up');
          stopPomodoro(timer);
        }
      });
    }

    //Body Widget tree
    return Column(
      children: <Widget>[
        Container(
          height: deviceHeight * 0.1,
          color: kPrimaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  tasks.elementAt(1),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            alignment: Alignment.center,
            height: deviceHeight * 0.30,
            width: deviceWidth,
            color: kPrimaryColor,
            child: Text(
              '$time',
              style: TextStyle(
                fontSize: 60.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: deviceHeight * 0.10,
            width: deviceWidth,
            color: kPrimaryColor,
            child: const Text(
              'o o o o',
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 40.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            height: deviceHeight * 0.1,
            width: deviceWidth,
            color: kPrimaryColor,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: taskList.length,
                itemBuilder: (context, index) => taskListBuilder(index)),
          ),
        ]),
        !sessionOngoing
            ? Container(
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
              )
            : Container(
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
                            onPressed: () => {print('pause')},
                            child: Text('Pause'),
                            style: ElevatedButton.styleFrom(
                              primary: kTertiaryColor,
                              minimumSize: Size(150, 48),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => {stopPomodoro()},
                            child: Text('Stop'),
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
              )
      ],
    );
  }
}
