import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

import 'test_data.dart';

void main() {
  test('info has trades', () async {
    var hasTrades = await infoHasTrades(
      base64.decode(testMarketAdress),
      base64.decode(testNicotinAdress),
    );
    if (hasTrades != false) {
      fail('there should not be any trades on that adress');
    }
  });
  test('info market', () async {
    var marketInfo = await infoMarket(
      base64.decode(testMarketAdress),
    );
    if (marketInfo.name != 'Bitcoin Ftem') {
      fail('the name of that market should be bitcoin ftem');
    }
  });
  test('info search', () async {
    var foundMarkets = await infoSearch('ftem');
    if (foundMarkets.length != 2) {
      fail('the length of found markets should be equal to 2');
    }
  });
  test('info user', () async {
    var userInfo = await infoUser(
      base64.decode(testAlcoholAdress),
    );
    if (userInfo.name != 'Alcohol') {
      fail('user name should be equal to Alcohol');
    }
  });
  test('info messages', () async {
    var messages = await infoMessages(
      base64.decode(testAlcoholAdress),
      base64.decode(testMarketAdress),
    );
    if (messages.length != 0) {
      fail('there should not be any messages on that user');
    }
  });
}
