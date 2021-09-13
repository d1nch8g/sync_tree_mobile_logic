import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';
import 'api.pb.dart';
import 'api.pbgrpc.dart';
import 'api.dart';

class UserCalls {
  static Future<bool> create() async {
    var keysString = await Storage.loadKeys();
    var publicName = await Storage.loadPublicName();
    var keys = Keys.fromSingleString(multiKeyStirng: keysString);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      keys.message.public.bytes,
      publicName,
    ]);
    final response = await stub
        .userCreate(
      UserCreateRequest(
        publicKey: keys.personal.public.bytes,
        messsageKey: keys.message.public.bytes,
        publicName: publicName,
        sign: sign,
      ),
    )
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      return Response(passed: false);
    });
    return response.passed;
  }

  static Future<bool> updateName(String name) async {
    var storageKey = await Storage.loadKeys();
    var keys = Keys.fromSingleString(multiKeyStirng: storageKey);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      keys.message.public.bytes,
      name,
    ]);
    final response = await stub.userUpdate(
      UserUpdateRequest(
        publicKey: keys.personal.public.bytes,
        messsageKey: keys.message.public.bytes,
        publicName: name,
        sign: sign,
      ),
    );
    if (response.passed) {
      Storage.savePublicName(name);
      return true;
    }
    return false;
  }

  static Future<bool> sendMain(int amount, String recieverAdress) async {
    var keysString = await Storage.loadKeys();
    var keys = Keys.fromSingleString(multiKeyStirng: keysString);
    var adressBytes = base64.decode(recieverAdress);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      amount,
      adressBytes,
    ]);
    final response = await stub.userSend(
      UserSendRequest(
        publicKey: keys.personal.public.bytes,
        sendAmount: Int64(amount),
        recieverAdress: adressBytes,
        sign: sign,
      ),
    );
    if (response.passed) {
      var curBalance = await Storage.loadMainBalance();
      Storage.saveMainBalance(curBalance - amount);
      return true;
    }
    return false;
  }

  static Future<bool> deposit(String marketAdress, int amount) async {
    var keys = Keys.fromSingleString(multiKeyStirng: await Storage.loadKeys());
    var bytesMarketAdress = base64.decode(marketAdress);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      bytesMarketAdress,
      amount,
    ]);
    final response = await stub.userDeposit(
      UserDepositRequest(
        publicKey: keys.personal.public.bytes,
        marketAdress: bytesMarketAdress,
        amount: Int64(amount),
        sign: sign,
      ),
    );
    return response.passed;
  }

  static Future<bool> withdrawal(String marketAdress, int amount) async {
    var keys = Keys.fromSingleString(multiKeyStirng: await Storage.loadKeys());
    var bytesMarketAdress = base64.decode(marketAdress);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      bytesMarketAdress,
      amount,
    ]);
    final response = await stub.userWithdrawal(
      UserWithdrawalRequest(
        publicKey: keys.personal.public.bytes,
        marketAdress: bytesMarketAdress,
        amount: Int64(amount),
        sign: sign,
      ),
    );
    return response.passed;
  }

  static Future<bool> sendMessage(String marketAdress, String message) async {
    var keys = Keys.fromSingleString(multiKeyStirng: await Storage.loadKeys());
    var bytesMarketAdress = base64.decode(marketAdress);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      bytesMarketAdress,
      message,
    ]);
    final response = await stub.userSendMessage(
      UserSendMessageRequest(
        publicKey: keys.personal.public.bytes,
        adress: bytesMarketAdress,
        message: message,
        sign: sign,
      ),
    );
    return response.passed;
  }

  static Future<bool> buy(String marketAdress, int recieve, int offer) async {
    var keys = Keys.fromSingleString(multiKeyStirng: await Storage.loadKeys());
    var bytesMarketAdress = base64.decode(marketAdress);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      bytesMarketAdress,
      recieve,
      offer,
    ]);
    final response = await stub.userBuy(
      UserBuyRequest(
        publicKey: keys.personal.public.bytes,
        adress: bytesMarketAdress,
        recieve: Int64(recieve),
        offer: Int64(offer),
        sign: sign,
      ),
    );
    return response.passed;
  }

  static Future<bool> sell(String marketAdress, int recieve, int offer) async {
    var keys = Keys.fromSingleString(multiKeyStirng: await Storage.loadKeys());
    var bytesMarketAdress = base64.decode(marketAdress);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      bytesMarketAdress,
      recieve,
      offer,
    ]);
    final response = await stub.userSell(
      UserSellRequest(
        publicKey: keys.personal.public.bytes,
        adress: bytesMarketAdress,
        recieve: Int64(recieve),
        offer: Int64(offer),
        sign: sign,
      ),
    );
    return response.passed;
  }

  static Future<bool> cancelTrade(String marketAdress) async {
    var keys = Keys.fromSingleString(multiKeyStirng: await Storage.loadKeys());
    var bytesMarketAdress = base64.decode(marketAdress);
    var sign = await keys.personal.private.signList([
      keys.personal.public.bytes,
      bytesMarketAdress,
    ]);
    final response = await stub.userCancelTrade(
      UserCancelTradeRequest(
        publicKey: keys.personal.public.bytes,
        marketAdress: bytesMarketAdress,
        sign: sign,
      ),
    );
    return response.passed;
  }
}
