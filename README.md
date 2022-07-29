# zeit

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

******************************************************************
managePomodoroSession()
    -Starts a new session and counts it as complete if S-B-S-B-S-B are stringed together
    -Called by startPomodoro to log in sessions
    -After it logs in session, it determines next step and calls on startPomodoro() or startBreak(length)
startPomodoro() 
    -starts pomodoro, if completes, calls on managePomodoroSession to log it
pausePomodoro() - Pauses countdown without cancelling session and can be resumed without restarting new session
resumePomodoro() - Resumes countdown that was paused
stopPomodoro() - Stops pomodoro and nullifies Session.
startBreak(length) 
    -takes in legth of break and count's down a break.
    -Once done, it calls managePomdoroSession()
Animation for home page
-Crossfade colors between session and breaks

Once we start a session, we create a data structure that stores SelectedTask and currentSessionCount
Under selected task, an JSON object of start and end of a session is stored.
No of sessions is gotten by counting the number of these entries.
Piano
{
    startTime: datetime
    stopTime: datetime
}
{
    startTime: datetime
    stopTime: datetime
}
Study
{
    startTime: datetime
    stopTime: datetime
}
{
    startTime: datetime
    stopTime: datetime
}
on StartPomodoro()
    -get current time
    -get current TaskList
    
******************************************************************
Documentation.
-main.dart - entry of app
-constants.dart - holds apps constants like colors
Screens folder
    -home_screen.dart - holds the home screen for the app
Components Folder
    -body.dart - containers the body for home_screen.dart