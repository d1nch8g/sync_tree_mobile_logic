import 'dart:convert';
import 'dart:typed_data';

import 'package:sync_tree_mobile_logic/local/crypto.dart';
import 'package:sync_tree_mobile_logic/local/storage.dart';

import 'api.pb.dart';
import 'api.pbgrpc.dart';
import 'api.dart';

class MarketBalance {
  Uint8List adress;
  int balance;
  MarketBalance(
    this.adress,
    this.balance,
  );
}

class UserInfo {
  String name;
  int balance;
  Uint8List mesKey;
  List<MarketBalance> marketBalances;
  UserInfo(
    this.name,
    this.balance,
    this.mesKey,
    this.marketBalances,
  );
}

class SingleTrade {
  int offer;
  int recieve;
  SingleTrade(
    this.offer,
    this.recieve,
  );
}

class MarketInfo {
  String name;
  List<int> messageKey;
  String imageLink;
  String description;
  int operationCount;
  List<int> buys;
  List<int> sells;
  MarketInfo(
    this.name,
    this.messageKey,
    this.imageLink,
    this.description,
    this.operationCount,
    this.buys,
    this.sells,
  );

  List<SingleTrade> getAllBuys() {
    List<SingleTrade> tradeList = [];
    for (var i = 0; i < buys.length / 2; i++) {
      tradeList.add(
        SingleTrade(
          buys[i] * 2,
          buys[i] * 2 + 1,
        ),
      );
    }
    return tradeList;
  }

  List<SingleTrade> getAllSells() {
    List<SingleTrade> tradeList = [];
    for (var i = 0; i < sells.length / 2; i++) {
      tradeList.add(
        SingleTrade(
          sells[i] * 2,
          sells[i] * 2 + 1,
        ),
      );
    }
    return tradeList;
  }
}

class InfoCalls {
  static Future<bool> selfActiveTradesByAdress(String marketAdress) async {
    var keysStr = await Storage.loadKeys();
    var keys = Keys.fromSingleString(multiKeyStirng: keysStr);
    final response = await stub.infoHasTrades(
      InfoHasTradesRequest(
        userAdress: keys.personal.public.getAdressBytes(),
        marketAdress: base64.decode(marketAdress),
      ),
    );
    return response.passed;
  }

  static Future<MarketInfo> marketInfo(Uint8List marketAdress) async {
    final response = await stub.infoMarket(
      InfoMarketRequest(
        adress: marketAdress,
      ),
    );
    List<int> buys = [];
    List<int> sells = [];
    for (var i = 0; i < response.buys.length; i++) {
      buys.add(response.buys[i] as int);
    }
    for (var i = 0; i < response.sells.length; i++) {
      sells.add(response.sells[i] as int);
    }
    final MarketInfo marketInfo = MarketInfo(
      response.name,
      response.mesKey,
      response.img,
      response.descr,
      response.opCount.toInt(),
      buys,
      sells,
    );
    return marketInfo;
  }

  static Future<List<Uint8List>> searchMarkets(String info) async {
    final response = await stub.infoSearch(
      InfoSearchRequest(
        info: info,
      ),
    );
    List<Uint8List> markets = [];
    response.concMarkets.forEach((marketAdress) {
      markets.add(marketAdress as Uint8List);
    });
    return markets;
  }

  static Future<UserInfo> selfInfo() async {
    var keys = Keys.fromSingleString(multiKeyStirng: await Storage.loadKeys());
    final response = await stub.infoUser(
      InfoUserRequest(
        adress: keys.personal.public.getAdressBytes(),
      ),
    );
    List<MarketBalance> balances = [];
    for (var i = 0; i < response.marketAdresses.length; i++) {
      balances.add(
        MarketBalance(
          response.marketAdresses[i] as Uint8List,
          response.marketBalances[i].toInt(),
        ),
      );
    }
    return UserInfo(
      response.publicName,
      response.balance.toInt(),
      response.mesKey as Uint8List,
      balances,
    );
  }

  static Future<List<String>> messages(Uint8List marketAdress) async {
    var keys = Keys.fromSingleString(multiKeyStirng: await Storage.loadKeys());
    final response = await stub.infoMessages(
      InfoMessagesRequest(
        userAdress: keys.personal.public.getAdressBytes(),
        marketAdress: marketAdress,
      ),
    );
    return response.messages;
  }
}
