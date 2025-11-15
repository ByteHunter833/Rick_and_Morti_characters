import 'package:rika_and_morti_characters/models/character.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const String charactersTable = 'characters';
  static const String favoritesTable = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'rick_morty.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $charactersTable(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            status TEXT NOT NULL,
            species TEXT NOT NULL,
            type TEXT,
            gender TEXT NOT NULL,
            image TEXT NOT NULL,
            locationName TEXT NOT NULL,
            originName TEXT NOT NULL,
            isFavorite INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE $favoritesTable(
            id INTEGER PRIMARY KEY,
            characterId INTEGER NOT NULL,
            FOREIGN KEY (characterId) REFERENCES $charactersTable (id)
          )
        ''');
      },
    );
  }

  // Characters operations
  Future<void> insertCharacters(List<Character> characters) async {
    final db = await database;
    final batch = db.batch();

    for (var character in characters) {
      batch.insert(
        charactersTable,
        character.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Character>> getCharacters() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(charactersTable);
    return List.generate(maps.length, (i) => Character.fromMap(maps[i]));
  }

  // Favorites operations
  Future<void> addFavorite(int characterId) async {
    final db = await database;

    await db.insert(favoritesTable, {
      'characterId': characterId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    await db.update(
      charactersTable,
      {'isFavorite': 1},
      where: 'id = ?',
      whereArgs: [characterId],
    );
  }

  Future<void> removeFavorite(int characterId) async {
    final db = await database;

    await db.delete(
      favoritesTable,
      where: 'characterId = ?',
      whereArgs: [characterId],
    );

    await db.update(
      charactersTable,
      {'isFavorite': 0},
      where: 'id = ?',
      whereArgs: [characterId],
    );
  }

  Future<List<Character>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      charactersTable,
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Character.fromMap(maps[i]));
  }

  Future<List<int>> getFavoriteIds() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(favoritesTable);
    return List.generate(maps.length, (i) => maps[i]['characterId'] as int);
  }

  Future<void> clearCharacters() async {
    final db = await database;
    await db.delete(charactersTable);
  }
}
