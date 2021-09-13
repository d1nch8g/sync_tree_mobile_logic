import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

void main() {
  test('storage save value', () async {
    SharedPreferences.setMockInitialValues({});
    var storage = Storage();
    storage.savePassword('abcdefg');
  });
  test('storage load value', () async {
    SharedPreferences.setMockInitialValues({
      'password': 'abcdefg',
    });
    var storage = Storage();
    var loaded = await storage.loadPassword();
    if (loaded != 'abcdefg') {
      fail('value loaded from prefs is not matching');
    }
  });
  test('stream trigger event', () {
    var storage = Storage();
    storage.triggerStorageEvent(
      trigger: StorageEventTrigger.mainBalanceUpdate,
    );
  });
  test('stream function triggering test', () async {
    var valueToBeChanged = 1;
    var valueChanger = () {
      valueToBeChanged = 2;
    };
    Storage().createTriggerSubscription(
      trigger: StorageEventTrigger.mainBalanceUpdate,
      onTriggerEvent: valueChanger,
    );
    Storage().triggerStorageEvent(
      trigger: StorageEventTrigger.mainBalanceUpdate,
    );
    Future.delayed(Duration(seconds: 1), () {
      if (valueToBeChanged != 2) {
        fail('the value that needs to be changed is the same');
      }
    });
  });
}
