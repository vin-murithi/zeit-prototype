import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:zeit/controllers/database.dart';

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = "key-dark-mode";
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //Delete Task Dialog
  void showInputDeleteDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Center(
              child: Text('Confirm Reset'),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Center(
              child: Text(
                  'Are you sure you want to delete all your session Data?'),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              MaterialButton(
                color: kDanger,
                onPressed: () {
                  Database().deleteFile().then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'All your Data has been reset successfuly'))));
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    bool showTextInput = false;
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(
                context, Settings.getValue("key-session-duration", 2));
          },
          iconSize: 40,
        ),
        centerTitle: true,
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        //List with all settings tile
        children: [
          //User profile card
          buildUserProfileCard(),
          //General Settings tiles
          SettingsGroup(
            title: 'Appearance',
            children: <Widget>[
              buildDarkModeTile(context),
            ],
          ),
          SettingsGroup(
            title: 'General Settings',
            children: <Widget>[
              // buildSessionTimeTile(),
              buildChangeDurationTile(showTextInput, controller1, controller2),
            ],
          ),
          //Account Settings tiles
          SettingsGroup(
            title: 'Account Settings',
            children: <Widget>[
              // buildLogoutTile(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: buildDeleteAccountTile(),
              ),
            ],
          ),
          //Feedback  tiles
          // SettingsGroup(
          //   title: 'Feedback',
          //   children: <Widget>[
          //     buildReportBugTile(),
          //     buildGiveFeedbackTile(),
          //   ],
          // ),
        ],
      ),
    );
  }

//User Profile Card
  Widget buildUserProfileCard() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: const CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/images/user.png'),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zeit User',
                        textScaleFactor: 1.5,
                      ),
                      // Text('Time for what matters'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: GestureDetector(
                    onTap: (() {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Profiles not yet supported')));
                    }),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                            backgroundColor: Theme.of(context).shadowColor,
                            child: Center(child: Icon(Icons.edit))))),
              ),
            ],
          ),
        ],
      );

//General Settings tiles
  Widget buildDarkModeTile(BuildContext context) => SwitchSettingsTile(
      settingKey: 'key-dark-mode',
      title: 'Dark Mode',
      subtitle: '',
      leading: const Icon(Icons.contrast),
      onChange: (_) {});
//Account Settings tiles
  Widget buildLogoutTile() => SimpleSettingsTile(
      title: 'Logout',
      subtitle: 'Log out from this device',
      leading: const Icon(Icons.logout),
      onTap: () => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Log Out Clicked'))));
  Widget buildDeleteAccountTile() => SimpleSettingsTile(
      title: 'Reset Statistics',
      subtitle: 'Delete all session data from this account',
      leading: const Icon(Icons.delete),
      onTap: () => showInputDeleteDialog());

//Change duration SettingTile
  Widget buildChangeDurationTile(showTextInput, controller1, controller2) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10 , 0, 0),
      child: SimpleSettingsTile(
        title: 'Session Durations',
        subtitle: 'Change Session and break durations',
        leading: const Icon(Icons.timer),
        onTap: () => showModalBottomSheet(
          context: context,
          elevation: 5,
          isScrollControlled: showTextInput,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                child: SingleChildScrollView(child: const MyBottomSheet()),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            );
          },
        ),
      ),
    );
  }

//Feedback Tiles
  Widget buildReportBugTile() => SimpleSettingsTile(
      title: 'Report a bug',
      subtitle: '',
      leading: const Icon(Icons.bug_report),
      onTap: () => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Report a bug Clicked'))));
  Widget buildGiveFeedbackTile() => SimpleSettingsTile(
      title: 'Send Feedback',
      subtitle: '',
      leading: const Icon(Icons.thumb_up),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Send Feedback Clicked'))));
}

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({Key? key}) : super(key: key);

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool showTextInput = false;
  var sessionDuration;
  var selectedDuration;
  int? setSessionMinutes;
  int? setBreakMinutes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionDuration = Settings.getValue("key-session", 25);
    if (sessionDuration == 25) {
      selectedDuration = 1;
    } else if (sessionDuration == 50) {
      selectedDuration = 2;
    } else if (sessionDuration == 100) {
      selectedDuration = 3;
    } else {
      selectedDuration = 4;
      setSessionMinutes = sessionDuration;
      setBreakMinutes = Settings.getValue("key-break", 5);
    }
  }

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (!showTextInput) {
      return SizedBox(
        height: 230,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () async {
                    print('Pomodoro clicked');
                    setState(() {
                      selectedDuration = 1;
                    });
                    await Settings.setValue('key-session', 25);
                    await Settings.setValue('key-break', 5);
                  },
                  child: SizedBox(
                    width: 250,
                    height: 100,
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getCircleMarker(1),
                          Icon(
                            Icons.timer,
                            size: 50,
                          ),
                          Text(
                            'Classic Pomodoro',
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            '25 Minutes session',
                            textScaleFactor: 1,
                          ),
                          Text(
                            '5 Minutes break',
                            textScaleFactor: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Settings.setValue('key-session', 50);
                    await Settings.setValue('key-break', 10);
                    setState(() {
                      selectedDuration = 2;
                    });
                    print('concetration clicked');
                  },
                  child: SizedBox(
                    width: 250,
                    height: 100,
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getCircleMarker(2),
                          Icon(
                            Icons.access_time_filled,
                            size: 50,
                          ),
                          Text(
                            'Concetration Station',
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            '50 Minutes session',
                            textScaleFactor: 1,
                          ),
                          Text(
                            '10 Minutes break',
                            textScaleFactor: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Settings.setValue('key-session', 100);
                    await Settings.setValue('key-break', 20);
                    setState(() {
                      selectedDuration = 3;
                    });
                    print('transcedent clicked');
                  },
                  child: SizedBox(
                    width: 250,
                    height: 100,
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getCircleMarker(3),
                          Icon(
                            Icons.settings_accessibility_rounded,
                            size: 50,
                          ),
                          Text(
                            'Transcedent',
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            '100 Minutes session',
                            textScaleFactor: 1,
                          ),
                          Text(
                            '20 Minutes break',
                            textScaleFactor: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('custom clicked');
                    setState(() {
                      showTextInput = showTextInput ? false : true;
                    });
                    setState(() {
                      selectedDuration = 1;
                    });
                    print(showTextInput);
                  },
                  child: SizedBox(
                    width: 250,
                    height: 100,
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getCircleMarker(4),
                          Icon(
                            Icons.add_alarm,
                            size: 50,
                          ),
                          Text(
                            'Custom Duration',
                            textScaleFactor: 1.2,
                          ),
                          returnCustomDurations(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
            child: Text(
              'Enter your custom durations here',
              textScaleFactor: 1.3,
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: TextField(
              controller: controller1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Session Duration in Minutes',
                hintText: 'Add your Custom Session Time',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: TextField(
              controller: controller2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Break Duration in Minutes',
                hintText: 'Add your Custom Break Duration',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kTertiaryColor,
                minimumSize: Size(150, 48),
              ),
              onPressed: () async {
                await Settings.setValue(
                    'key-session', int.parse(controller1.text));
                await Settings.setValue(
                    'key-break', int.parse(controller2.text));
                setState(() {
                  showTextInput = false;
                  selectedDuration = 4;
                });
              },
              child: Text(
                'Update Durations',
                textScaleFactor: 1.1,
              ),
            ),
          ),
        ],
      );
    }
  }

  //Get a card marker for selected
  Widget getCircleMarker(passedId) {
    if (passedId == selectedDuration) {
      return Align(
          alignment: Alignment.topCenter, child: Icon(Icons.check_circle));
    } else {
      return Align(
          alignment: Alignment.topCenter, child: Icon(Icons.circle_outlined));
    }
  }

  Widget returnCustomDurations() {
    if (setSessionMinutes != null) {
      return Column(
        children: [
          Text('$setSessionMinutes Minutes Session'),
          Text('$setBreakMinutes Minutes Break'),
        ],
      );
    } else {
      return Column(
        children: [
          Text('Specify your own custom durations'),
          Text('Click to set'),
        ],
      );
    }
  }
}
