import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

//Colors
//General
//Color(0xff050a21);
const kTextColor = Color.fromARGB(255, 59, 59, 61);
const kPrimaryColor = Color(0xffF2F2F2);
const kSecondaryColor = Color.fromRGBO(119, 116, 116, 1);
const kTertiaryColor = Color(0xff353E58);
const kDefaultPadding = 20.0;
const kCardColor = Color(0xffFFFFFF);
const kSuccess = Color(0xff5cb85c);
const kDanger = Color(0xffC10000);
const kLightText = Color(0xffF2F2F2);
//Home Page
const kCountDownDial = Color.fromARGB(255, 250, 250, 250);

//Time
const kPomodoroSession = 2;
const kShortBreak = 1;
const kLongBreak = 2;
// const kPomodoroSession = 60 * 25;
// const kShortBreak = 60 * 5;
// const kLongBreak = 60 * 25;

Map<String, int> getSessionDuration(sessionDurationInt) {
  Map<String, int> duration = {};
  switch (sessionDurationInt) {
    case 2:
      {
        duration['session'] = 25;
        duration['break'] = 5;
      }
      break;
    case 3:
      {
        duration['session'] = 50;
        duration['break'] = 5;
      }
      break;
    case 4:
      {
        duration['session'] = 100;
        duration['break'] = 10;
      }
      break;
    //Comment Debug case when not in use
    case 5:
      {
        duration['session'] = 2;
        duration['break'] = 1;
      }
      break;
    default:
      {
        duration['session'] = 25;
        duration['break'] = 5;
      }
  }
  return duration;
}
