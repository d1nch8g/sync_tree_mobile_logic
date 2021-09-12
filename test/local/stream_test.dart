import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

class TestStreamHelperClass {
  TestStreamHelperClass.startExisting(Function whatToDo) {
    whatToDo();
  }
}

void main() {
  test('stream trigger event', () {
    triggerEvent(trigger: Trigger.mainBalanceUpdate);
  });
  test('stream function triggering test', () async {
    var valueToBeChanged = 1;
    var valueChanger = () {
      valueToBeChanged = 2;
    };
    createTriggerSubscription(
      trigger: Trigger.mainBalanceUpdate,
      onTriggerEvent: valueChanger,
    );
    triggerEvent(trigger: Trigger.mainBalanceUpdate);
    Future.delayed(Duration(seconds: 1), () {
      if (valueToBeChanged != 2) {
        fail('the value that needs to be changed is the same');
      }
    });
  });
}
