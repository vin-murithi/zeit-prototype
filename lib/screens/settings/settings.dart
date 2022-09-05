import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:zeit/controllers/database.dart';
import 'package:zeit/screens/home/home_screen.dart';

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = "key-dark-mode";
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //Delete Task
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
              buildSessionTimeTile(),
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
              const CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/images/penguin.jpg'),
                backgroundColor: Colors.transparent,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                      child: Text(
                        'Vin Murithi',
                        textScaleFactor: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                      child: Text('vin-murithi-zeit'),
                    ),
                  ],
                ),
              )
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
  //ToDo: use DropDown Tile
  Widget buildSessionTimeTile() => DropDownSettingsTile<int>(
        title: 'Session Duration',
        settingKey: 'key-session-duration',
        values: const <int, String>{
          2: '25/5 Session/Break',
          3: '50/5 Session/Break',
          4: '100/10 Session/Break',
          //Comment debug case when not in use
          5: '2/1 Debug time',
        },
        selected: 2,
        onChange: (value) {},
      );
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
