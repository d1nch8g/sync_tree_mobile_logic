import 'package:flutter_test/flutter_test.dart';

import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

void main() {
  test('generate key band', () async {
    var band = await generateKeysBand();
    if (band.messagePrivate.pem.length < 100 ||
        band.messagePublic.pem.length < 100 ||
        band.personalPrivate.pem.length < 100 ||
        band.personalPublic.pem.length < 100) {
      fail('something is not generated correctly');
    }
  });
  test('private key from bytes test', () async {
    var band = await generateKeysBand();
    var priv = PrivateKey.fromBytes(bytes: band.messagePrivate.bytes);
    if (priv.pem.length < 50) {
      fail('failed to convert bytes to private key');
    }
  });
  test('private key from pem', () async {
    var band = await generateKeysBand();
    var priv = PrivateKey.fromPEM(pem: band.messagePrivate.pem);
    if (priv.bytes.length < 50) {
      fail('failed to convert pem string to private key');
    }
  });
  test('private key integer to bytes', () async {
    var band = await generateKeysBand();
    var bytes = band.personalPrivate.intToBytes(19237);
    print(bytes);
    print(bytes[0]);
  });
}
