import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rika_and_morti_characters/providers/characyter_provider.dart';
import 'package:rika_and_morti_characters/screens/main_screen.dart';
import 'package:rika_and_morti_characters/themes/dark_mode.dart';
import 'package:rika_and_morti_characters/themes/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => CharacterProvider(),
      child: MyApp(isDarkMode: isDarkMode),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: lightMode,

      darkTheme: darkMode,
      home: MainScreen(isDarkMode: _isDarkMode, onThemeToggle: _toggleTheme),
    );
  }
}
