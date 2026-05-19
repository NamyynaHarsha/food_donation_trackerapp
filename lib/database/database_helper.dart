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
    await _initDB(
      'food_donation.db',
    );

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

      version: 4,

      onCreate: _createDB,
    );
  }

  // =========================
  // CREATE DATABASE
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

        address TEXT,

        profileImage TEXT
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

        requesterId INTEGER,

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

    final db =
    await database;

    return await db.insert(

      'users',

      user,

      conflictAlgorithm:
      ConflictAlgorithm.abort,
    );
  }

  // =========================
  // LOGIN USER
  // =========================

  Future<Map<String, dynamic>?>
  loginUser(

      String email,
      String password,

      ) async {

    final db =
    await database;

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
  // GET USER BY EMAIL
  // =========================

  Future<Map<String, dynamic>?>
  getUserByEmail(
      String email,
      ) async {

    final db =
    await database;

    final result = await db.query(

      'users',

      where: 'email = ?',

      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // =========================
  // GET USER BY ID
  // =========================

  Future<Map<String, dynamic>?>
  getUserById(
      int id,
      ) async {

    final db =
    await database;

    final result = await db.query(

      'users',

      where: 'id = ?',

      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // =========================
  // UPDATE USER PROFILE
  // =========================

  Future<int> updateUserProfile(

      int userId,

      Map<String, dynamic> user,

      ) async {

    final db =
    await database;

    return await db.update(

      'users',

      user,

      where: 'id = ?',

      whereArgs: [userId],
    );
  }

  // =========================
  // INSERT DONATION
  // =========================

  Future<int> insertDonation(
      Map<String, dynamic> donation,
      ) async {

    final db =
    await database;

    return await db.insert(

      'donations',

      donation,
    );
  }

  // =========================
  // GET DONATIONS
  // =========================

  Future<List<Map<String, dynamic>>>
  getDonations() async {

    final db =
    await database;

    return await db.query(

      'donations',

      where:
      'status IS NULL OR status != ?',

      whereArgs: ['Completed'],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // GET AVAILABLE DONATIONS
  // =========================

  Future<List<Map<String, dynamic>>>
  getAvailableDonations(
      int currentUserId,
      ) async {

    final db =
    await database;

    return await db.query(

      'donations',

      where:
      'status IS NULL OR status != ?',

      whereArgs: ['Completed'],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // GET USER DONATIONS
  // =========================

  Future<List<Map<String, dynamic>>>
  getUserDonations(
      int donorId,
      ) async {

    final db =
    await database;

    return await db.query(

      'donations',

      where: 'donorId = ?',

      whereArgs: [donorId],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // GET COMPLETED DONATIONS
  // =========================

  Future<List<Map<String, dynamic>>>
  getCompletedDonations(
      int donorId,
      ) async {

    final db =
    await database;

    return await db.query(

      'donations',

      where:
      'donorId = ? AND status = ?',

      whereArgs: [
        donorId,
        'Completed',
      ],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // UPDATE DONATION
  // =========================

  Future<int> updateDonation(

      int donationId,

      Map<String, dynamic> donation,

      ) async {

    final db =
    await database;

    return await db.update(

      'donations',

      donation,

      where: 'id = ?',

      whereArgs: [donationId],
    );
  }

  // =========================
  // DELETE DONATION
  // =========================

  Future<int> deleteDonation(
      int donationId,
      ) async {

    final db =
    await database;

    return await db.delete(

      'donations',

      where: 'id = ?',

      whereArgs: [donationId],
    );
  }

  // =========================
  // UPDATE DONATION STATUS
  // =========================

  Future<int> updateDonationStatus(

      int donationId,

      String status,

      ) async {

    final db =
    await database;

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

    final db =
    await database;

    return await db.insert(

      'requests',

      request,
    );
  }

  // =========================
  // CHECK DUPLICATE REQUEST
  // =========================

  Future<bool> hasUserRequested(

      int donationId,

      int requesterId,

      ) async {

    final db =
    await database;

    final result = await db.query(

      'requests',

      where:
      'donationId = ? AND requesterId = ?',

      whereArgs: [
        donationId,
        requesterId,
      ],
    );

    return result.isNotEmpty;
  }

  // =========================
  // GET INCOMING REQUESTS
  // =========================

  Future<List<Map<String, dynamic>>>
  getIncomingRequests(
      int donorId,
      ) async {

    final db =
    await database;

    return await db.query(

      'requests',

      where: 'donorId = ?',

      whereArgs: [donorId],

      orderBy: 'id DESC',
    );
  }

  // =========================
  // GET USER REQUESTS
  // =========================

  Future<List<Map<String, dynamic>>>
  getUserRequests(
      int requesterId,
      ) async {

    final db =
    await database;

    return await db.query(

      'requests',

      where: 'requesterId = ?',

      whereArgs: [requesterId],

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

    final db =
    await database;

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
  // GET TOTAL USERS
  // =========================

  Future<int> getTotalUsers() async {

    final db =
    await database;

    final result =
    await db.rawQuery(

      'SELECT COUNT(*) FROM users',
    );

    return Sqflite.firstIntValue(
      result,
    ) ??
        0;
  }

  // =========================
  // REQUEST COUNT
  // =========================

  Future<int> getRequestCount(
      int donationId,
      ) async {

    final db =
    await database;

    final result =
    await db.rawQuery(

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