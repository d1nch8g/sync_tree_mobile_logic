import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

import 'test_data.dart';

void main() {
  test('user create call', () async {
    var newKeys = await generateKeys();
    SharedPreferences.setMockInitialValues({
      'keys': newKeys.allKeysString,
      'publicName': 'holac',
    });
    var userCalls = UserCalls();
    var created = await userCalls.create();
    if (created == false) {
      fail('new user should be created');
    }
  });
  test('update user information', () async {
    SharedPreferences.setMockInitialValues({
      'keys': alcoholKeys,
      'publicName': 'Alcohol',
    });
    var userCalls = UserCalls();
    var updated = await userCalls.updateName('Alcohol');
    if (updated == false) {
      fail('user infotmation should be updated');
    }
  });
  test('send main call', () async {
    SharedPreferences.setMockInitialValues({
      'keys': alcoholKeys,
      'publicName': 'Alcohol',
      'balance': 10,
    });
    var userCalls = UserCalls();
    var nicoKeys = Keys.fromSingleString(multiKeyStirng: nicotinKeys);
    var triggerWasTriggered = false;
    Function trigger = () {
      triggerWasTriggered = true;
    };
    Storage().createTriggerSubscription(
      trigger: Trigger.mainBalanceUpdate,
      onTriggerEvent: trigger,
    );
    var operated = await userCalls.sendMain(
      1,
      nicoKeys.persPub.getAdressBase64(),
    );
    if (operated != true) {
      fail('this transaction should go well');
    }
    Future.delayed(Duration(seconds: 1), () {
      if (triggerWasTriggered == false) {
        fail('trigger should have been triggered');
      }
    });
  });
  test('send message call', () async {
    SharedPreferences.setMockInitialValues({
      'keys': alcoholKeys,
      'publicName': 'Alcohol',
    });
    var userCalls = UserCalls();
    var operated = await userCalls.sendMessage(testMarketAdress, 'hola');
    if (operated == false) {
      fail('the message is not delivered');
    }
  });
  test('buy call', () async {
    SharedPreferences.setMockInitialValues({
      'keys': alcoholKeys,
      'publicName': 'Alcohol',
      'balance': 10,
    });
    var userCalls = UserCalls();
    var operated = await userCalls.sell(testMarketAdress, 10, 10);
    if (operated == false) {
      fail('the buy call was not operated');
    }
  });
  test('sell call', () async {
    SharedPreferences.setMockInitialValues({
      'keys': alcoholKeys,
      'publicName': 'Alcohol',
      'balance': 10,
    });
    var userCalls = UserCalls();
    var operated = await userCalls.buy(testMarketAdress, 10, 10);
    if (operated == false) {
      fail('the sell call was not operated');
    }
  });
  // test('deposit call', () async {
  //   SharedPreferences.setMockInitialValues({
  //     'keys': alcoholKeys,
  //     'publicName': 'Alcohol',
  //     'balance': 10,
  //   });
  //   var userCalls = UserCalls();
  //   var operated = await userCalls.deposit(testMarketAdress, 100);
  //   if (operated == false) {
  //     fail('deposit request should return true');
  //   }
  // });
  // test('withdrawal call', () async {
  //   SharedPreferences.setMockInitialValues({
  //     'keys': alcoholKeys,
  //     'publicName': 'Alcohol',
  //     'balance': 10,
  //   });
  //   var userCalls = UserCalls();
  //   var operated = await userCalls.withdrawal(testMarketAdress, 100);
  //   if (operated == false) {
  //     fail('withdrawal request should return true');
  //   }
  // });
}
