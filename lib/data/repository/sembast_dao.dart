import 'package:bankr/data/json/i_json_converter.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/data/repository/i_dao.dart';
import 'package:sembast/sembast.dart';

class SembastDao<E extends IPersist> extends IDao<E> {
  final StoreRef<String, Map<String, dynamic>> _store;
  final Database _db;
  final IJsonConverter<E> _jsonConverter;

  SembastDao(this._store, this._db, this._jsonConverter);

  @override
  void delete(E saveableI) async {
	  final finder = Finder(filter: Filter.byKey(saveableI.uuid));
    await _store.delete(
      _db,
      finder: finder,
    );
  }

  @override
  Future<List<E>> getAll() async {
    final finder = Finder();
    final recordSnapshots = await _store.find(
      _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
	    final saveableI = _jsonConverter.fromMap(snapshot.value);
      return saveableI;
    }).toList();
  }

  @override
  insert(E saveableI) async {
	  var record = _store.record(saveableI.uuid);
	  await record.put(_db, _jsonConverter.toMap(saveableI));
  }

  @override
  update(E saveableI) async {
	  final finder = Finder(filter: Filter.byKey(saveableI.uuid));
    await _store.update(
      _db,
      _jsonConverter.toMap(saveableI),
      finder: finder,
    );
  }
}
