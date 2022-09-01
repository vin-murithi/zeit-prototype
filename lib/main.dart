import 'package:flutter/material.dart';
import 'screens/settings/settings.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:zeit/screens/home/home_screen.dart';

//Main method: entry, to initilize settings and run app
Future<void> main() async {
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
        theme: returnTheme(isDarkMode),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData returnTheme(isDarkMOde) {
    ThemeData theme;
    if (isDarkMOde) {
      theme = ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 36, 36, 36),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
        shadowColor: Color.fromARGB(255, 49, 49, 49),
      );
    } else {
      theme = ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
        primaryColor: const Color.fromARGB(255, 226, 226, 226),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black87,
        ),
        shadowColor: Colors.white,
      );
    }

    return theme;
  }
}
