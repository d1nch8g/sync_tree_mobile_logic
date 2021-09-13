import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';
import 'api.pb.dart';
import 'api.pbgrpc.dart';
import 'api.dart';

class UserNetCalls {
  late Storage storage;
  UserCalls() {
    storage = Storage();
  }

  Future<bool> create() async {
    var keysString = await storage.loadKeys();
    var publicName = await storage.loadPublicName();
    var keys = Keys.fromSingleString(multiKeyStirng: keysString);
    var sign = await keys.persPriv.signList([
      keys.persPub.bytes,
      keys.mesPub.bytes,
      publicName,
    ]);
    final response = await stub
        .userCreate(
      UserCreateRequest(
        publicKey: keys.persPub.bytes,
        messsageKey: keys.mesPub.bytes,
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
}

Future<bool> userUpdate() async {
  var storageKey = await loadValue(StorageKey.keys);
  var publicName = await loadValue(StorageKey.publicName);
  var keys = Keys.fromSingleString(multiKeyStirng: storageKey);
  var sign = await keys.persPriv.signList([
    keys.persPub.bytes,
    keys.mesPub.bytes,
    publicName,
  ]);
  final response = await stub.userUpdate(
    UserUpdateRequest(
      publicKey: keys.persPub.bytes,
      messsageKey: keys.mesPub.bytes,
      publicName: publicName,
      sign: sign,
    ),
  );

  return response.passed;
}

Future<bool> userSend(int amount, String recieverAdress) async {
  var keysString = await loadValue(StorageKey.keys);
  var keys = Keys.fromSingleString(multiKeyStirng: keysString);
  var adressBytes = base64.decode(recieverAdress);
  var sign = await keys.persPriv.signList([
    keys.persPub.bytes,
    Int64(amount),
    adressBytes,
  ]);
  final response = await stub.userSend(
    UserSendRequest(
      publicKey: keys.persPub.bytes,
      sendAmount: Int64(amount),
      recieverAdress: adressBytes,
      sign: sign,
    ),
  );
  if (response.passed) {
    var curBalance = int.parse(await loadValue(StorageKey.mainBalance));
    saveValue(StorageKey.mainBalance, (curBalance - amount).toString());
    triggerStorageEvent(trigger: StorageEventTrigger.mainBalanceUpdate);
  }
  return response.passed;
}

Future<bool> userDeposit(
  Uint8List publicKey,
  Uint8List marketAdress,
  int amount,
  Uint8List sign,
) async {
  final response = await stub.userDeposit(
    UserDepositRequest(
      publicKey: publicKey,
      marketAdress: marketAdress,
      amount: Int64(amount),
      sign: sign,
    ),
  );
  return response.passed;
}

Future<bool> userWithdrawal(
  Uint8List publicKey,
  Uint8List marketAdress,
  int amount,
  Uint8List sign,
) async {
  final response = await stub.userWithdrawal(
    UserWithdrawalRequest(
      publicKey: publicKey,
      marketAdress: marketAdress,
      amount: Int64(amount),
      sign: sign,
    ),
  );
  return response.passed;
}

Future<bool> userSendMessage(
  Uint8List publicKey,
  Uint8List marketAdress,
  String message,
  Uint8List sign,
) async {
  final response = await stub.userSendMessage(
    UserSendMessageRequest(
      publicKey: publicKey,
      adress: marketAdress,
      message: message,
      sign: sign,
    ),
  );
  return response.passed;
}

Future<bool> userBuy(
  Uint8List publicKey,
  Uint8List adress,
  int recieve,
  int offer,
  Uint8List sign,
) async {
  final response = await stub.userBuy(
    UserBuyRequest(
      publicKey: publicKey,
      adress: adress,
      recieve: Int64(recieve),
      offer: Int64(offer),
      sign: sign,
    ),
  );
  return response.passed;
}

Future<bool> userSell(
  Uint8List publicKey,
  Uint8List adress,
  int recieve,
  int offer,
  Uint8List sign,
) async {
  final response = await stub.userSell(
    UserSellRequest(
      publicKey: publicKey,
      adress: adress,
      recieve: Int64(recieve),
      offer: Int64(offer),
      sign: sign,
    ),
  );
  return response.passed;
}

Future<bool> userCancelTrade(
  Uint8List publicKey,
  Uint8List marketAdress,
  Uint8List sign,
) async {
  final response = await stub.userCancelTrade(
    UserCancelTradeRequest(
      publicKey: publicKey,
      marketAdress: marketAdress,
      sign: sign,
    ),
  );
  return response.passed;
}
