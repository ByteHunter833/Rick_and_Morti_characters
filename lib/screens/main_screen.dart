import 'package:flutter/material.dart';
import 'package:rika_and_morti_characters/screens/characters_screen.dart';
import 'package:rika_and_morti_characters/screens/favourites_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CharactersScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text('Rick and Morty Characters'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: widget.onThemeToggle,
                  tooltip: 'Toggle theme',
                ),
              ],
            )
          : null,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Characters',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
