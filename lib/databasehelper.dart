import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PiDataModel {
  final DateTime  timeStamp;
  final int temperature;
  final int random;

  const PiDataModel({
    required this.timeStamp,
    required this.temperature,
    required this.random,
  });
  // Convert a model into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'timeStamp': timeStamp,
      'temperature': temperature,
      'random': random,
    };
  }

  factory PiDataModel.fromMap(Map<String, dynamic> map) {
    return PiDataModel(
      timeStamp: map['timeStamp'],
      temperature: map['temperature'],
      random: map['random'],
    );
  }
  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'PiDataModel{timeStamp: $timeStamp, temparature: $temperature, random: $random}';
  }
}

class PiDatabase {
  static final PiDatabase instance = PiDatabase._init();
  static Database? _database;

  PiDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('PiDatabase.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
   //Make changes based on attribute names
    await db.execute('''
      CREATE TABLE pi_data_table (
        timestamp INTEGER PRIMARY KEY,
        temperature INTEGER,
        random INTEGER,
      )
    ''');
  }

  Future<int> insertdata(PiDataModel piDataModel) async {
    final db = await database;
    return await db.insert('pi_data_table', piDataModel.toMap());
  }

  Future<List<PiDataModel>> getdata() async {
    final db = await database;
    final maps = await db.query('pi_data_table');
    return List.generate(maps.length, (i) {
      return PiDataModel.fromMap(maps[i]);
    });
  }
}
