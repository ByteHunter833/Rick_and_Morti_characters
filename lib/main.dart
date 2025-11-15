import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rika_and_morti_characters/providers/characyter_provider.dart';
import 'package:rika_and_morti_characters/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
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
    return ChangeNotifierProvider(
      create: (_) => CharacterProvider(),
      child: MaterialApp(
        title: 'Rick and Morty',
        debugShowCheckedModeBanner: false,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        ),
        home: MainScreen(isDarkMode: _isDarkMode, onThemeToggle: _toggleTheme),
      ),
    );
  }
}
