import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper instance =
      DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // =========================
  // DATABASE
  // =========================

  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database =
        await _initDB('food_donation.db');

    return _database!;
  }

  Future<Database> _initDB(
    String filePath,
  ) async {

    final dbPath =
        await getDatabasesPath();

    final path =
        join(dbPath, filePath);

    return await openDatabase(

      path,

      version: 1,

      onCreate: _createDB,
    );
  }

  // =========================
  // CREATE TABLES
  // =========================

  Future _createDB(
    Database db,
    int version,
  ) async {

    // USERS TABLE

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        phone TEXT,
        address TEXT
      )
    ''');

    // DONATIONS TABLE

    await db.execute('''
      CREATE TABLE donations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        title TEXT,
        quantity TEXT,
        description TEXT,
        location TEXT,
        expiryDate TEXT,
        imageUrl TEXT,

        donorId INTEGER,
        donorName TEXT,
        donorEmail TEXT,

        donorPhone TEXT,
        donorAddress TEXT,

        status TEXT
      )
    ''');

    // REQUESTS TABLE

    await db.execute('''
      CREATE TABLE requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        donationId INTEGER,
        foodTitle TEXT,

        donorId INTEGER,
        donorName TEXT,

        donorPhone TEXT,
        donorAddress TEXT,

        requesterName TEXT,
        requesterPhone TEXT,
        requesterAddress TEXT,

        status TEXT,
        requestDate TEXT
      )
    ''');
  }

  // =========================
  // REGISTER USER
  // =========================

  Future<int> registerUser(
    Map<String, dynamic> user,
  ) async {

    final db = await instance.database;

    return await db.insert(

      'users',

      user,

      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  // =========================
  // LOGIN USER
  // =========================

  Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {

    final db = await instance.database;

    final result = await db.query(

      'users',

      where:
          'email = ? AND password = ?',

      whereArgs: [
        email,
        password,
      ],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // =========================
  // INSERT DONATION
  // =========================

  Future<int> insertDonation(
    Map<String, dynamic> donation,
  ) async {

    final db = await instance.database;

    return await db.insert(
      'donations',
      donation,
    );
  }

  // =========================
  // GET AVAILABLE DONATIONS
  // =========================

  Future<List<Map<String, dynamic>>>
      getDonations() async {

    final db = await instance.database;

    return await db.query(

      'donations',

      where: 'status = ?',

      whereArgs: ['Available'],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // GET USER DONATIONS
  // =========================

  Future<List<Map<String, dynamic>>>
      getUserDonations(
    String donorEmail,
  ) async {

    final db = await instance.database;

    return await db.query(

      'donations',

      where: 'donorEmail = ?',

      whereArgs: [donorEmail],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // UPDATE DONATION STATUS
  // =========================

  Future<int> updateDonationStatus(
    int donationId,
    String status,
  ) async {

    final db = await instance.database;

    return await db.update(

      'donations',

      {
        'status': status,
      },

      where: 'id = ?',

      whereArgs: [donationId],
    );
  }

  // =========================
  // INSERT REQUEST
  // =========================

  Future<int> insertRequest(
    Map<String, dynamic> request,
  ) async {

    final db = await instance.database;

    return await db.insert(
      'requests',
      request,
    );
  }

  // =========================
  // GET INCOMING REQUESTS
  // =========================

  Future<List<Map<String, dynamic>>>
      getIncomingRequests(
    String donorName,
  ) async {

    final db = await instance.database;

    return await db.query(

      'requests',

      where: 'donorName = ?',

      whereArgs: [donorName],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // GET MY REQUESTS
  // =========================

  Future<List<Map<String, dynamic>>>
      getMyRequests(
    String requesterName,
  ) async {

    final db = await instance.database;

    return await db.query(

      'requests',

      where: 'requesterName = ?',

      whereArgs: [requesterName],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // UPDATE REQUEST STATUS
  // =========================

  Future<int> updateRequestStatus(
    int requestId,
    String status,
  ) async {

    final db = await instance.database;

    return await db.update(

      'requests',

      {
        'status': status,
      },

      where: 'id = ?',

      whereArgs: [requestId],
    );
  }

  // =========================
  // GET REQUEST COUNT
  // =========================

  Future<int> getRequestCount(
    int donationId,
  ) async {

    final db = await instance.database;

    final result = await db.rawQuery(

      '''
      SELECT COUNT(*) as count
      FROM requests
      WHERE donationId = ?
      ''',

      [donationId],
    );

    return Sqflite.firstIntValue(
          result,
        ) ??
        0;
  }
}