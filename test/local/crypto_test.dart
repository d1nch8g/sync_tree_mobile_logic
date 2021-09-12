import 'dart:typed_data';

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
    if (bytes[0] != 37) {
      fail('failed to convert ineger value to bytes');
    }
  });
  test('private key sign data array', () async {
    var band = await generateKeysBand();
    var bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
    var sign = await band.personalPrivate.signData(bytes);
    if (sign.length != 512) {
      fail('sign length is wrong, something is bad ${sign.length}');
    }
  });
  test('private array to bytes', () async {
    var band = await generateKeysBand();
    var bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
    var integer = 282;
    var string = 'alloha';
    var byteSum = band.personalPrivate.transformListToByteArray([
      bytes,
      integer,
      string,
    ]);
    var goodByteSum = Uint8List.fromList(
      [1, 2, 3, 4, 5, 26, 1, 0, 0, 0, 0, 0, 0, 97, 108, 108, 111, 104, 97],
    );
    if (byteSum.toString() != goodByteSum.toString()) {
      fail('something went wrong with bytesum');
    }
  });
  test('private key sign data', () async {
    var band = await generateKeysBand();
    var bytesToSign = Uint8List.fromList([1, 2, 3, 4, 5, 6]);
    var sign = await band.personalPrivate.signList([
      bytesToSign,
      bytesToSign,
      bytesToSign,
    ]);
    if (sign.length != 512) {
      fail('sign generated incorrectly');
    }
  });
  test('public encrypt, private decrypt', () async {
    var band = await generateKeysBand();
    var untouchedMessage = 'some text';
    var encryptedMessage = await band.messagePublic.encrypt(untouchedMessage);
    var decryptedMessage = await band.messagePrivate.decrypt(encryptedMessage);
    if (decryptedMessage != untouchedMessage ||
        encryptedMessage == untouchedMessage) {
      fail('some error in ecnryption/decryption module');
    }
  });
  test('public key from bytes', () async {
    var band = await generateKeysBand();
    var priv = PublicKey.fromBytes(bytes: band.messagePublic.bytes);
    if (priv.pem.length < 50) {
      fail('failed to convert bytes to public key');
    }
  });
  test('public key from pem', () async {
    var band = await generateKeysBand();
    var priv = PublicKey.fromPEM(pem: band.messagePublic.pem);
    if (priv.bytes.length < 50) {
      fail('failed to convert pem string to public key');
    }
  });
  test('public get hash adress bytes/base64', () async {
    var band = await generateKeysBand();
    var adressBase64 = band.personalPublic.getAdressBase64();
    var adressBytes = band.personalPublic.getAdressBytes();
    if (adressBytes.length < 50 || adressBase64.length < 50) {
      fail('key bytes converted to adress incorrectly');
    }
  });
  test('key band single string exort/import', () async {
    var keyBand = await generateKeysBand();
    var keyBandString = keyBand.multiKeyStirng;
    var keyBandFromString = KeysBand.fromSingleString(
      multiKeyStirng: keyBandString,
    );
    if (keyBand.messagePrivate.toString() !=
            keyBandFromString.messagePrivate.toString() ||
        keyBand.personalPublic.toString() !=
            keyBand.personalPublic.toString()) {
      fail('some error importing/exporting keys from/to single string line');
    }
  });
}
