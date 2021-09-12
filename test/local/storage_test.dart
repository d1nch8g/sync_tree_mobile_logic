import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

void main() {
  test('storage save value test', () async {
    SharedPreferences.setMockInitialValues({});
    saveValue(StorageKey.connectedWallets, 'value');
  });
  test('storage load value test', () async {
    SharedPreferences.setMockInitialValues({
      'connectedWallets': 'value',
    });
    var loaded = await loadValue(StorageKey.connectedWallets);
    if (loaded != 'value') {
      fail('value loaded from prefs is not matching $loaded');
    }
  });
}
