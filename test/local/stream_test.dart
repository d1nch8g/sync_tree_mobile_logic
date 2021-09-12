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
  test('stream create listener function', () {
    var doSomething = () {
      var x = 1 + 3 + 2;
    };
    createTriggerListener(
      trigger: Trigger.mainBalanceUpdate,
      onTriggerEvent: doSomething,
    );
  });
  test('stream function triggering test', () {
    var valueToBeChanged = 1;
    var valueChanger = () {
      valueToBeChanged = 2;
    };
    createTriggerListener(
      trigger: Trigger.mainBalanceUpdate,
      onTriggerEvent: valueChanger,
    );
    triggerEvent(trigger: Trigger.mainBalanceUpdate);
    sleep(Duration(seconds: 1));
    if (valueToBeChanged == 1) {
      fail('value should be changed to 2 after change being triggered');
    }
  });
}
