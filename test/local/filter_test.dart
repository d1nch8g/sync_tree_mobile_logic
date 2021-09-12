import 'package:flutter_test/flutter_test.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

void main() {
  test('filter profanity check', () {
    var filter = Filter();
    var checked = filter.operateCheck('shit');
    if (checked != 'name contains profane words') {
      fail('filter did not detect bad word');
    }
  });
  test('filter check short name', () {
    var filter = Filter();
    var checked = filter.operateCheck('shr');
    if (checked != 'name is too short') {
      fail('filter did not detect too short name');
    }
  });
  test('filter short name check', () {
    var filter = Filter();
    var checked = filter.operateCheck('71827&!@#*sad');
    if (checked == 'name contains bad letters') {
      fail('filter did not detect bad symbols');
    }
  });
  test('filter check long name', () {
    var filter = Filter();
    var checked = filter.operateCheck('askjdbaskjdnkasjdnasdnjkkj');
    if (checked != 'name is too long') {
      fail('fitler did not detect too long name');
    }
  });
  test('filter normal name check', () {
    var filter = Filter();
    var checked = filter.operateCheck('NormalName');
    if (checked != '') {
      fail('this is normal name and should not cause any errors');
    }
  });
}
