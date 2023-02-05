import 'package:psinsx/models/insx_sqlite_model.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDataBase = 'insx.db';
  final String tableDataBase = 'tableInsx';
  final int version = 1;

  final String columnid = 'id';
  final String columnca = 'ca';
  final String columnpea_no = 'pea_no';
  final String columncus_name = 'cus_name';
  final String columncus_id = 'cus_id';
  final String columninvoice_no = 'invoice_no';
  final String columnbill_date = 'bill_date';
  final String columnbp_no = 'bp_no';
  final String columnwrite_id = 'write_id';
  final String columnportion = 'portion';
  final String columnptc_no = 'ptc_no';
  final String columnaddress = 'address';
  final String columnnew_period_date = 'new_period_date';
  final String columnwrite_date = 'write_date';
  final String columnlat = 'lat';
  final String columnlng = 'lng';
  final String columninvoice_status = 'invoice_status';
  final String columnnoti_date = 'noti_date';
  final String columnupdate_date = 'update_date';
  final String columntimestamp = 'timestamp';
  final String columnworkImage = 'workImage';
  final String columnworker_code = 'worker_code';
  final String columnworker_name = 'worker_name';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDataBase),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE $tableDataBase ($columnid INTEGER PRIMARY KEY, $columnca TEXT, $columnpea_no TEXT, $columncus_name TEXT, $columncus_id TEXT, $columninvoice_no TEXT, $columnbill_date TEXT, $columnbp_no TEXT, $columnwrite_id TEXT, $columnportion TEXT, $columnptc_no TEXT, $columnaddress TEXT, $columnnew_period_date TEXT, $columnwrite_date TEXT, $columnlat TEXT, $columnlng TEXT, $columninvoice_status TEXT, $columnnoti_date TEXT, $columnupdate_date TEXT, $columntimestamp TEXT, $columnworkImage TEXT, $columnworker_code TEXT, $columnworker_name TEXT)');
    }, version: version);
  }

  Future<Database> connectedDtabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDataBase));
  }

  Future<Null> insertValueToSQLite(InsxSQLiteModel model) async {
    Database database = await connectedDtabase();
    try {
      database.insert(
        tableDataBase,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('##### insert value Success ###');
    } catch (e) {}
  }
  Future<List<InsxSQLiteModel>> readSQLite()async{
    Database database = await connectedDtabase();
    try {

      List<InsxSQLiteModel> listModel = [];

      List<Map<String, dynamic>> maps = await database.query(tableDataBase);
      for (var item in maps) {
        listModel.add(InsxSQLiteModel.fromMap(item));
      }
      return listModel;
      
    } catch (e) {
      return null;
    }

  }

  Future<Null> deleteAllData()async{
    Database database = await connectedDtabase();
    try {
      await database.delete(tableDataBase);
    } catch (e) {
    }
  }

  Future<Null> editValueWhereId(int id)async{
    Database database = await connectedDtabase();
    Map<String, dynamic> map = {};
    map['invoice_status'] = MyConstant.valueInvoiceStatus;
    try {
      await database
      .update(tableDataBase, map, where: '$columnid = $id')
      .then((value) => print('success edit ที่ id $id'));

      
    } catch (e) {
      print('Error at eitValue SQLite = ${e.toString()}');
    }
  }
}
