import 'package:flutter_test/flutter_test.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

void main() {
  test('stream trigger event', () {
    triggerEvent(trigger: Trigger.mainBalanceUpdate);
  });
  test('stream create listener function', () {
    var doSomething = () {
      var x = 1 + 3;
      return;
    };
  });
}
