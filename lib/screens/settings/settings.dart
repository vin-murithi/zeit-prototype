import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeit/constants.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: kCardColor,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: 80,
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: kTextColor,
                          child: const Icon(
                            Icons.contrast,
                            size: 40,
                            color: kLightText,
                          ),
                        ),
                        title: Text(
                          'Dark Mode',
                          textScaleFactor: 1.5,
                        ),
                        trailing: const Icon(
                          Icons.toggle_on,
                          size: 50,
                          color: Colors.black,
                        ),
                        onTap: () {
                          print('toggle dark mode');
                        },
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.97,
                    height: 200,
                    child: Column(
                      children: [
                        Card(
                          elevation: 0,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: kCardColor,
                          child: const SizedBox(
                            height: 70,
                            child: Center(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: kTextColor,
                                  child: Icon(
                                    Icons.delete,
                                    size: 40,
                                    color: kLightText,
                                  ),
                                ),
                                title: Text(
                                  'Delete all Data',
                                  textScaleFactor: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 260,
                                height: 50,
                                child: const TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText:
                                        "Type the word 'delete' and press OK ",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: kDanger,
                                        onPrimary: Colors.white,
                                      ),
                                      onPressed: () {
                                        print('delete');
                                      },
                                      child: const Text(
                                        'Delete',
                                        textScaleFactor: 1.2,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.97,
                    height: 250,
                    child: Column(
                      children: [
                        Card(
                          elevation: 0,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: kCardColor,
                          child: const SizedBox(
                            height: 70,
                            child: Center(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: kTextColor,
                                  child: Icon(
                                    Icons.feedback,
                                    size: 40,
                                    color: kLightText,
                                  ),
                                ),
                                title: Text(
                                  'Feedback',
                                  textScaleFactor: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 260,
                                height: 110,
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 10,
                                  minLines: 4,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText:
                                        'Write your anonymous feedback here..',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: kTertiaryColor,
                                        onPrimary: Colors.white,
                                      ),
                                      onPressed: () {
                                        print('send feedback');
                                      },
                                      child: const Text(
                                        'Send',
                                        textScaleFactor: 1.2,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
