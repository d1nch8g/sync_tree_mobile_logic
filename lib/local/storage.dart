import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

var storageStreamController = StreamController<StorageEventTrigger>.broadcast();
var storageStream = storageStreamController.stream;

enum StorageEventTrigger {
  publicNameUpdate,
  mainBalanceUpdate,
  marketBalanceUpdate,
  marketMessagesUpdate,
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

  void savePassword(String password) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
  }

  Future<String> loadPassword() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('password') ?? '';
  }

  void saveMainBalance(int balance) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('balance', balance);
    triggerStorageEvent(trigger: StorageEventTrigger.mainBalanceUpdate);
  }

  Future<int> loadMainBalance() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('balance') ?? 0;
  }

  void saveConnectedWalletsAdressesList(List<String> wallets) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList('wallets', wallets);
  }

  Future<List<String>> loadConnectedWallets() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('wallets') ?? [];
  }

  void saveMarketBalanceByAdress(String adress, int balance) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(adress, balance);
    triggerStorageEvent(trigger: StorageEventTrigger.marketBalanceUpdate);
  }

  Future<int> loadMarketBalance(String adress) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(adress) ?? 0;
  }

  void savePublicName(String name) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    triggerStorageEvent(trigger: StorageEventTrigger.publicNameUpdate);
  }

  Future<String> loadPublicName() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'name_err';
  }

  void saveSearchCache(String cache) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('cache', cache);
  }

  Future<String> loadSeachCache(String cache) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('cache') ?? '';
  }

  void triggerStorageEvent({
    required StorageEventTrigger trigger,
  }) {
    storageStreamController.add(trigger);
  }

  createTriggerSubscription({
    required StorageEventTrigger trigger,
    required Function onTriggerEvent,
  }) {
    storageStream.listen((event) {
      if (trigger == event) {
        onTriggerEvent();
      }
    });
  }
}
