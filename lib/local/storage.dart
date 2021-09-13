import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

var storageStreamController = StreamController<Trigger>.broadcast();
var storageStream = storageStreamController.stream;

enum Trigger {
  publicNameUpdate,
  mainBalanceUpdate,
  marketBalanceUpdate,
  marketMessagesUpdate,
}

class Storage {
  static void saveKeys(String keys) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('keys', keys);
  }

  static Future<String> loadKeys() async {
    var prefs = await SharedPreferences.getInstance();
    var keysString = prefs.getString('keys');
    if (keysString == null) {
      throw Exception('keys should never be null');
    }
    return keysString;
  }

  static void savePassword(String password) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
  }

  static Future<String> loadPassword() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('password') ?? '';
  }

  static void saveMainBalance(int balance) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('balance', balance);
    triggerStorageEvent(trigger: Trigger.mainBalanceUpdate);
  }

  static Future<int> loadMainBalance() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('balance') ?? 0;
  }

  static void saveConnectedWalletsAdressesList(List<String> wallets) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList('wallets', wallets);
  }

  static Future<List<String>> loadConnectedWallets() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('wallets') ?? [];
  }

  static void saveMarketBalanceByAdress(String adress, int balance) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(adress, balance);
    triggerStorageEvent(trigger: Trigger.marketBalanceUpdate);
  }

  static Future<int> loadMarketBalance(String adress) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(adress) ?? 0;
  }

  static void savePublicName(String name) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    triggerStorageEvent(trigger: Trigger.publicNameUpdate);
  }

  static Future<String> loadPublicName() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'name_err';
  }

  static void saveSearchCache(String cache) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('cache', cache);
  }

  static Future<String> loadSeachCache(String cache) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('cache') ?? '';
  }

  static void triggerStorageEvent({
    required Trigger trigger,
  }) {
    storageStreamController.add(trigger);
  }

  static createTriggerSubscription({
    required Trigger trigger,
    required Function onTriggerEvent,
  }) {
    storageStream.listen((event) {
      if (trigger == event) {
        onTriggerEvent();
      }
    });
  }
}
