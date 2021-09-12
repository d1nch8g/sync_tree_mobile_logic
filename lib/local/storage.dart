import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  keys,
  password,
  mainBalance,
  connectedWallets,
  searchCache,
  publicName,
}

final mapping = {
  StorageKey.keys: "keys",
  StorageKey.password: "password",
  StorageKey.mainBalance: "mainBalance",
  StorageKey.connectedWallets: "connectedWallets",
  StorageKey.searchCache: "searchCache",
  StorageKey.publicName: "publicName",
};

void saveValue(StorageKey key, String value) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString(mapping[key] ?? '', value);
}

Future<String> loadValue(StorageKey key) async {
  var prefs = await SharedPreferences.getInstance();
  print(prefs.getString(mapping[key] ?? ''));
  return prefs.getString(mapping[key] ?? '') ?? '';
}
