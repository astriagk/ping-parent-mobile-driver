import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// SQLite-based offline queue for position updates
class PositionQueueService {
  static final PositionQueueService _instance =
      PositionQueueService._internal();
  static Database? _database;
  static const String _tableName = 'position_queue';

  PositionQueueService._internal();

  factory PositionQueueService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'position_queue.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            trip_id TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            speed REAL NOT NULL,
            heading REAL NOT NULL,
            accuracy REAL NOT NULL,
            timestamp TEXT NOT NULL,
            type TEXT NOT NULL,
            synced INTEGER DEFAULT 0,
            created_at TEXT NOT NULL
          )
        ''');
        await db
            .execute('CREATE INDEX idx_synced ON $_tableName (synced, type)');
      },
    );
  }

  Future<int> enqueue({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required double accuracy,
    required String timestamp,
    required String type,
  }) async {
    final db = await database;
    return await db.insert(_tableName, {
      'trip_id': tripId,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'heading': heading,
      'accuracy': accuracy,
      'timestamp': timestamp,
      'type': type,
      'synced': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getPending({
    required String type,
    int limit = 50,
  }) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: 'synced = 0 AND type = ?',
      whereArgs: [type],
      orderBy: 'created_at ASC',
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> getPendingApiPositions({
    int limit = 10,
  }) async {
    return await getPending(type: 'api', limit: limit);
  }

  Future<int> markSynced(List<int> ids) async {
    if (ids.isEmpty) return 0;

    final db = await database;
    final placeholders = ids.map((_) => '?').join(',');
    return await db.rawUpdate(
      'UPDATE $_tableName SET synced = 1 WHERE id IN ($placeholders)',
      ids,
    );
  }

  Future<int> cleanupSynced({
    Duration olderThan = const Duration(hours: 24),
  }) async {
    final db = await database;
    final cutoff = DateTime.now().subtract(olderThan).toIso8601String();
    return await db.delete(
      _tableName,
      where: 'synced = 1 AND created_at < ?',
      whereArgs: [cutoff],
    );
  }

  Future<int> getPendingCount({String? type}) async {
    final db = await database;
    final result = await db.rawQuery(
      type != null
          ? 'SELECT COUNT(*) as count FROM $_tableName WHERE synced = 0 AND type = ?'
          : 'SELECT COUNT(*) as count FROM $_tableName WHERE synced = 0',
      type != null ? [type] : [],
    );
    return result.first['count'] as int;
  }

  Future<int> clearAll() async {
    final db = await database;
    return await db.delete(_tableName);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
