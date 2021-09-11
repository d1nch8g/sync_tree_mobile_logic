import 'package:flutter_test/flutter_test.dart';

import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

void main() {
  test('generate a couple of keys', () {
    var keyPair = Keys().generateKeyPair(2048);
    if (keyPair.length != 2) {
      fail('there should be 2 keys generated');
    }
  });
  test('convert key to bytes', () {
    var keyPair = Keys().generateKeyPair(2048);
    var firstArr = Keys().keyToBytes(keyPair[0]);
    var secondArr = Keys().keyToBytes(keyPair[1]);
    if (firstArr.length < 1000 || firstArr.length > 1500) {
      fail('key converted with error ${firstArr.length}');
    }
    if (secondArr.length < 200 || secondArr.length > 400) {
      fail('key converted with error ${secondArr.length}');
    }
  });
  test('bytes to public key', () {
    var keyPair = Keys().generateKeyPair(2048);
    var bytes = Keys().keyToBytes(keyPair[1]);
    var key = Keys().bytesToPublic(bytes);
    if (key.length < 100) {
      fail('converted back incorrectly');
    }
  });
  test('bytes to private key', () {
    var keyPair = Keys().generateKeyPair(2048);
    var bytes = Keys().keyToBytes(keyPair[0]);
    var key = Keys().bytesToPublic(bytes);
    if (key.length < 400) {
      fail('converted back incorrectly');
    }
  });
}
