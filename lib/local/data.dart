import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum Keys {
  keys,
  password,
  mainBalance,
  connectedWallets,
  searchCache,
  publicName,
}

var mainStreamController = StreamController<Trigger>.broadcast();
var mainStream = mainStreamController.stream;

enum Trigger {
  publicNameUpdate,
  mainBalanceUpdate,
  marketBalanceUpdate,
  marketMessagesUpdate,
}

void triggerEvent({
  required Trigger trigger,
}) {
  mainStreamController.add(trigger);
}

createTriggerSubscription({
  required Trigger trigger,
  required Function onTriggerEvent,
}) {
  mainStream.listen((event) {
    if (trigger == event) {
      onTriggerEvent();
    }
  });
}


class Storage {
  void saveKeys(String keys) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('keys', keys);
  }

  Future<String> loadKeys() async {
    var prefs = await SharedPreferences.getInstance();
    var keysString = prefs.getString('keys');
    if (keysString == null) {
      throw Exception('keys should never be null');
    }
    return keysString;
  }

  void updatePassword()
}

final mapping = {
  StorageKey.keys: "keys",
  StorageKey.password: "password",
  StorageKey.mainBalance: "mainBalance",
  StorageKey.connectedWallets: "connectedWallets",
  StorageKey.searchCache: "searchCache",
  StorageKey.publicName: "publicName",
};

Future<String> loadValue(StorageKey key) async {}