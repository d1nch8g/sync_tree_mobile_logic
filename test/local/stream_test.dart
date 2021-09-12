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
    triggerCreateListener(
      trigger: Trigger.mainBalanceUpdate,
      onEventAction: doSomething,
    );
  });
  test('stream check if listener is killed after a while', () {
    var doSomething = () {
      var x = 1 + 2 + 3;
    };
    TestStreamHelperClass.startExisting(() {});
    
  });
}
