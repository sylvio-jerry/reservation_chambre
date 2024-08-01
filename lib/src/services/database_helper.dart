import 'package:reservation/src/models/chambre.dart';
import 'package:reservation/src/models/client.dart';
import 'package:reservation/src/models/reservation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reservation_db.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const clientTable = '''
    CREATE TABLE clients (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      numClient TEXT NOT NULL,
      nom TEXT NOT NULL,
      tel TEXT NOT NULL,
      email TEXT NOT NULL
    )
    ''';

    const chambreTable = '''
    CREATE TABLE chambres (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      prix INTEGER NOT NULL
    )
    ''';

    const reservationTable = '''
    CREATE TABLE reservations (
      numero TEXT PRIMARY KEY,
      chambreId INTEGER NOT NULL,
      clientId INTEGER NOT NULL,
      dateEntree TEXT NOT NULL,
      dateSortie TEXT NOT NULL,
      FOREIGN KEY (chambreId) REFERENCES chambres(id) ON DELETE CASCADE,
      FOREIGN KEY (clientId) REFERENCES clients(id) ON DELETE CASCADE
    )
    ''';

    await db.execute(clientTable);
    await db.execute(chambreTable);
    await db.execute(reservationTable);
  }

  //******************************* */ client *************************************//

  Future<int> insertClient(Client client) async {
    final db = await instance.database;
    return await db.insert('clients', client.toMap());
  }

  Future<List<Client>> getClients() async {
    final db = await instance.database;
    final clients = await db.query('clients', orderBy: 'nom');
    return clients.map((json) => Client.fromMap(json)).toList();
  }

  Future<int> updateClient(Client client) async {
    final db = await instance.database;
    return db.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteClient(int id) async {
    final db = await instance.database;
    return await db.delete(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

Future<List<Client>> getFilteredClients(String query) async {
  final db = await database;
  if (query.isEmpty) {
    return getClients();
  } else {
    final List<Map<String, dynamic>> maps = await db.query(
      'clients',
      where: 'nom LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Client.fromMap(maps[i]);
    });
  }
}

  //******************************* */ chambre *************************************//

  Future<int> insertChambre(Chambre chambre) async {
    final db = await instance.database;
    return await db.insert('chambres', chambre.toMap());
  }

  Future<List<Chambre>> getChambres() async {
    final db = await instance.database;
    final chambre = await db.query('chambres');
    return chambre.map((json) => Chambre.fromMap(json)).toList();
  }

  Future<int> updateChambre(Chambre chambre) async {
    final db = await instance.database;
    return db.update(
      'chambres',
      chambre.toMap(),
      where: 'id = ?',
      whereArgs: [chambre.id],
    );
  }

  Future<int> deleteChambre(int id) async {
    final db = await instance.database;
    return await db.delete(
      'chambres',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Chambre>> getFilteredChambres(String query) async {
  final db = await database;
  if (query.isEmpty) {
    return getChambres(); // Retourne toutes les chambres si la requête est vide
  } else {
    final List<Map<String, dynamic>> maps = await db.query(
      'chambres',
      where: 'type LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Chambre.fromMap(maps[i]);
    });
  }
}


  //******************************* */ reservation *************************************//

  Future<void> insertReservation(Reservation reservation) async {
    final db = await instance.database;
    await db.insert(
      'reservations',
      reservation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all Reservations
  Future<List<Reservation>> getReservations() async {
    final db = await instance.database;
    final maps = await db.query('reservations');

    if (maps.isNotEmpty) {
      return maps.map((map) => Reservation.fromMap(map)).toList();
    } else {
      return [];
    }
  }

  // Get a Reservation by ID
  Future<Reservation?> getReservation(String numero) async {
    final db = await instance.database;
    final maps = await db.query(
      'reservations',
      columns: null,
      where: 'numero = ?',
      whereArgs: [numero],
    );

    if (maps.isNotEmpty) {
      return Reservation.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Delete Reservation
  Future<void> deleteReservation(String numero) async {
    final db = await instance.database;
    await db.delete(
      'reservations',
      where: 'numero = ?',
      whereArgs: [numero],
    );
  }

  // Update Reservation
  Future<void> updateReservation(Reservation reservation) async {
    final db = await instance.database;
    await db.update(
      'reservations',
      reservation.toMap(),
      where: 'numero = ?',
      whereArgs: [reservation.numero],
    );
  }

  Future<List<Reservation>> getFilteredReservations(String query) async {
  final db = await database;
  if (query.isEmpty) {
    return getReservations(); // Retourne toutes les réservations si la requête est vide
  } else {
    final List<Map<String, dynamic>> maps = await db.query(
      'reservations',
      where: 'numero LIKE ? OR clientId IN (SELECT id FROM clients WHERE nom LIKE ?)',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Reservation.fromMap(maps[i]);
    });
  }
}


}
