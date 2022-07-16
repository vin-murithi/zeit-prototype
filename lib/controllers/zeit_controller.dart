//This is a file that contains logic separate from UI
import 'dart:async';

class Pomodoro {
  //Pomodoro Properties
  late int session;
  late int shortBreak;
  late int longBreak;
  bool sessionOngoing = false;

  //Class constructor to initialize properties
  Pomodoro(int session, int shortBreak, int longBreak) {
    this.session = session * 60;
    this.shortBreak = shortBreak * 60;
    this.longBreak = longBreak * 60;
  }

  //Start pomodoro method
  void startPomodoro() {
    
    var time = this.shortBreak;
    //create object of Timer class and countdown session
    Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time > 0) {
        this.sessionOngoing = true;
        time--;
        print('This is the rem seconds $time');
      } else {
        this.sessionOngoing = false;
        print('$time seconds is up');
        stopPomodoro(timer);
      }
    });
  }

  //Stop timer method
  void stopPomodoro(timer) {
    timer.cancel();
    print('Timer Cancelled');
  }
}
