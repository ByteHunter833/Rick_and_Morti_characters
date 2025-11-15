import 'package:flutter/foundation.dart';
import 'package:rika_and_morti_characters/services/api_service.dart';
import 'package:rika_and_morti_characters/models/character.dart';
import 'package:rika_and_morti_characters/services/database_service.dart';

enum SortOption { name, status, species }

class CharacterProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();

  List<Character> _characters = [];
  List<Character> _favorites = [];
  bool _isLoading = false;
  bool _hasError = false;
  int _currentPage = 1;
  bool _hasMorePages = true;
  SortOption _sortOption = SortOption.name;

  List<Character> get characters => _characters;
  List<Character> get favorites => _sortedFavorites;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  SortOption get sortOption => _sortOption;

  List<Character> get _sortedFavorites {
    final sorted = List<Character>.from(_favorites);
    switch (_sortOption) {
      case SortOption.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.status:
        sorted.sort((a, b) => a.status.compareTo(b.status));
        break;
      case SortOption.species:
        sorted.sort((a, b) => a.species.compareTo(b.species));
        break;
    }
    return sorted;
  }

  Future<void> loadInitialCharacters() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // Try to load from API
      final charactersFromApi = await _apiService.getCharacters(page: 1);
      _characters = charactersFromApi;
      _currentPage = 1;
      _hasMorePages = true;

      // Cache in database
      await _dbService.insertCharacters(charactersFromApi);

      // Load favorites
      await _loadFavorites();
      _updateFavoriteStatus();
    } catch (e) {
      // If API fails, load from database
      try {
        final charactersFromDb = await _dbService.getCharacters();
        if (charactersFromDb.isNotEmpty) {
          _characters = charactersFromDb;
          await _loadFavorites();
          _updateFavoriteStatus();
        } else {
          _hasError = true;
        }
      } catch (dbError) {
        _hasError = true;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreCharacters() async {
    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentPage++;
      final newCharacters = await _apiService.getCharacters(page: _currentPage);

      if (newCharacters.isEmpty) {
        _hasMorePages = false;
      } else {
        _characters.addAll(newCharacters);
        await _dbService.insertCharacters(newCharacters);
        _updateFavoriteStatus();
      }
    } catch (e) {
      _currentPage--;
      _hasMorePages = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    _favorites = await _dbService.getFavorites();
  }

  void _updateFavoriteStatus() {
    final favoriteIds = _favorites.map((c) => c.id).toSet();
    for (var character in _characters) {
      character.isFavorite = favoriteIds.contains(character.id);
    }
  }

  Future<void> toggleFavorite(Character character) async {
    character.isFavorite = !character.isFavorite;

    if (character.isFavorite) {
      await _dbService.addFavorite(character.id);
      _favorites.add(character);
    } else {
      await _dbService.removeFavorite(character.id);
      _favorites.removeWhere((c) => c.id == character.id);
    }

    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  Future<void> refreshCharacters() async {
    _currentPage = 0;
    _hasMorePages = true;
    _characters.clear();
    await loadInitialCharacters();
  }
}
