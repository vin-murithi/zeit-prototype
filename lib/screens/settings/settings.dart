import 'package:flutter/material.dart';
import 'package:zeit/constants.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatefulWidget {
  static const keyDarkMode = "key-dark-mode";
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
          color: kSecondaryColor,
          iconSize: 40,
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Settings',
          style: TextStyle(color: kTextColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        //List with all settings tile
        children: [
          //User profile card
          buildUserProfileCard(),
          buildDarkModeTile(context),
          //General Settings tiles
          SettingsGroup(
            title: 'General Settings',
            children: <Widget>[
              buildSessionTimeTile(),
            ],
          ),
          //Account Settings tiles
          SettingsGroup(
            title: 'Account Settings',
            children: <Widget>[buildLogoutTile(), buildDeleteAccountTile()],
          ),
          //Feedback  tiles
          SettingsGroup(
            title: 'Feedback',
            children: <Widget>[buildReportBugTile(), buildGiveFeedbackTile()],
          ),
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
        values: <int, String>{
          2: '25/5 Session/Break',
          3: '50/5 Session/Break',
          4: '100/10 Session/Break',
        },
        selected: 2,
        onChange: (value) {
          debugPrint('key-dropdown-email-view: $value');
        },
      );
//Account Settings tiles
  Widget buildLogoutTile() => SimpleSettingsTile(
      title: 'Logout',
      subtitle: 'Log out from this device',
      leading: const Icon(Icons.logout),
      onTap: () => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Log Out Clicked'))));
  Widget buildDeleteAccountTile() => SimpleSettingsTile(
      title: 'Delete account',
      subtitle: 'Delete your account and all data',
      leading: const Icon(Icons.delete),
      onTap: () => ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Log Out Clicked'))));
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
