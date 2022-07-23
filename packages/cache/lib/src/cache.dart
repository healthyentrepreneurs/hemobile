library cache;

import 'package:cache/cache.dart';
import 'package:cache/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

/// {@template cache_client}
/// An in-memory cache client.
/// {@endtemplate}
class CacheClient {
  static Store? _store;

  /// {@macro cache_client}
  CacheClient() : _cache = <String, Object>{};

  final Map<String, Object> _cache;

  /// Writes the provide [key], [value] pair to the in-memory cache.
  void write<T extends Object>({required String key, required T value}) {
    _cache[key] = value;
  }

  /// Defaults to `null` if no value exists for the provided key.
  T? read<T extends Object>({required String key}) {
    final value = _cache[key];
    if (value is T) return value;
    return null;
  }

  Future<int> writeUser(Userobject userobject) async {
    final store = await _getStore();
    final userBox = store.box<Userobject>();
    return userBox.put(userobject);
  }

  Future<Userobject?> readUser(int userid) async {
    final store = await _getStore();
    final userBox = store.box<Userobject>();
    // final query =(userBox.q)
    final user = userBox.get(userid);
    return user;
  }

  Future<int> writeLang(Langobject langobject) async {
    final store = await _getStore();
    final langBox = store.box<Langobject>();
    return langBox.put(langobject);
  }

  Future<Lang> readLang() async {
    final store = await _getStore();
    final langBox = store.box<Langobject>();
    // final user = langBox.get(userid);
    final langs = langBox.getAll();
    return langs.isEmpty ? Lang.empty : langs.first;
  }

  Future<int> updateLang(int id, String code, String uppercode) async {
    final store = await _getStore();
    final langBox = store.box<Langobject>();
    final lang = langBox.get(id)!;
    if (code != lang.code) {
      lang
        ..code = code
        ..uppercode = uppercode;
      langBox.put(lang);
      return 1;
    }
    return 0;
  }

  Future<Store> _getStore() async {
    if (_store == null) {
      _store?.close();
      final dir = await getApplicationDocumentsDirectory();
      _store = Store(getObjectBoxModel(), directory: '${dir.path}/objectbox');
    }
    return _store!;
  }

  Future<void> closeDb() async {
    final store = await _getStore();
    store.close();
  }
}
