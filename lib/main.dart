import 'package:flutter/material.dart';
import 'screens/settings/settings.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:zeit/screens/home/home_screen.dart';

//Main method: entry, to initilize settings and run app
Future<void> main() async{
  await initSettings();
  runApp(const MyApp());
}

//Creates SharePreferenceCach object, initializes it and initializes the Settings widget.
Future<void> initSettings() async {
      SharePreferenceCache spCache = SharePreferenceCache();
      await spCache.init();
      await Settings.init(cacheProvider: spCache);
    }
//My main App Class
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const String darkModeKey = "key-dark-mode";
    return ValueChangeObserver<bool>(
      cacheKey: darkModeKey,
      defaultValue: true,
      builder: (_, isDarkMode, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zeit',
        theme: isDarkMode
            ? ThemeData.dark().copyWith(
                primaryColor: Colors.teal,
                scaffoldBackgroundColor: const Color(0xFF170635),
                canvasColor: const Color(0xFF170635))
            : ThemeData.light(),
        home: const HomeScreen(),
      ),
    );
  }
}
