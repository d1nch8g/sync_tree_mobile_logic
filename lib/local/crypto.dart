import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/random/fortuna_random.dart';

List<String> generateKeyPEMpair(int bitLength) {
  final secureRandom = FortunaRandom();
  final seedSource = Random.secure();
  final seeds = <int>[];
  for (var i = 0; i < 32; i++) {
    seeds.add(seedSource.nextInt(255));
  }
  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
  final keyGen = RSAKeyGenerator()
    ..init(
      ParametersWithRandom(
        RSAKeyGeneratorParameters(
          BigInt.parse('65537'),
          bitLength,
          64,
        ),
        secureRandom,
      ),
    );
  final pair = keyGen.generateKeyPair();
  final myPublic = pair.publicKey as RSAPublicKey;
  final myPrivate = pair.privateKey as RSAPrivateKey;
  var priv = CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(myPrivate);
  var pub = CryptoUtils.encodeRSAPublicKeyToPemPkcs1(myPublic);
  return [priv, pub];
}

Future<KeysBand> generateKeysBand() async {
  var persKeyPEMpair = await compute(generateKeyPEMpair, 4096);
  var mesKeyPEMpair = await compute(generateKeyPEMpair, 2048);
  return KeysBand.fromKeys(
    personalPrivate: PrivateKey.fromPEM(pem: persKeyPEMpair[0]),
    personalPublic: PublicKey.fromPEM(pem: persKeyPEMpair[1]),
    messagePrivate: PrivateKey.fromPEM(pem: mesKeyPEMpair[0]),
    messagePublic: PublicKey.fromPEM(pem: mesKeyPEMpair[1]),
  );
}

class PrivateKey {
  late String pem;
  late Uint8List bytes;

  PrivateKey.fromBytes({
    required Uint8List bytes,
  }) {
    this.bytes = bytes;
    var key = CryptoUtils.rsaPrivateKeyFromDERBytesPkcs1(bytes);
    this.pem = CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(key);
  }

  PrivateKey.fromPEM({
    required String pem,
  }) {
    this.pem = pem;
    this.bytes = CryptoUtils.getBytesFromPEMString(pem);
  }

  Uint8List intToBytes(int value) {
    return Uint8List(8)..buffer.asByteData().setInt64(0, value, Endian.big);
  }

  Future<Uint8List> signData(Uint8List data) async {
    var key = CryptoUtils.rsaPrivateKeyFromPemPkcs1(pem);
    var sign = CryptoUtils.rsaSign(key, data, algorithmName: 'SHA-512/RSA');
    return sign;
  }

  Uint8List transformListToByteArray(List<dynamic> values) {
    List<int> byteArray = [];
    values.forEach((singleListValue) {
      if (singleListValue is String) {
        var stringAsBytes = singleListValue.codeUnits;
        stringAsBytes.forEach((byte) {
          byteArray.add(byte);
        });
      }
      if (singleListValue is Uint8List) {
        singleListValue.forEach((byte) {
          byteArray.add(byte);
        });
      }
      if (singleListValue is int) {
        Uint8List intAsBytes = intToBytes(singleListValue);
        intAsBytes.forEach((byte) {
          byteArray.add(byte);
        });
      }
    });
    return Uint8List.fromList(byteArray);
  }

  Future<Uint8List> signList(List<dynamic> values) async {
    var bytes = transformListToByteArray(values);
    return await signData(bytes);
  }

  Future<String> decrypt(String encrypted) async {
    var key = CryptoUtils.rsaPrivateKeyFromPemPkcs1(pem);
    var decrypted = CryptoUtils.rsaDecrypt(encrypted, key);
    return decrypted;
  }
}

class PublicKey {
  late String pem;
  late Uint8List bytes;

  PublicKey.fromBytes({
    required Uint8List bytes,
  }) {
    this.bytes = bytes;
    var key = CryptoUtils.rsaPublicKeyFromDERBytesPkcs1(bytes);
    this.pem = CryptoUtils.encodeRSAPublicKeyToPem(key);
  }

  PublicKey.fromPEM({
    required String pem,
  }) {
    this.pem = pem;
    this.bytes = CryptoUtils.getBytesFromPEMString(pem);
  }

  Uint8List getAdressBytes() {
    return Digest('SHA-512').process(bytes);
  }

  String getAdressBase64() {
    var adress = Digest('SHA-512').process(bytes);
    return base64.encode(adress);
  }

  Future<String> encrypt(String message) async {
    var key = CryptoUtils.rsaPublicKeyFromPemPkcs1(pem);
    var encrypted = CryptoUtils.rsaEncrypt(message, key);
    return encrypted;
  }
}

class KeysBand {
  late String multiKeyStirng;
  late PrivateKey personalPrivate, messagePrivate;
  late PublicKey personalPublic, messagePublic;

  KeysBand.fromSingleString({
    required String multiKeyStirng,
  }) {
    var keysListToCheck = multiKeyStirng.split('|');
    if (keysListToCheck.length != 4) {
      throw Exception(
        'Impossible to from keys from a string with wrong length',
      );
    }
    this.personalPrivate = PrivateKey.fromPEM(pem: keysListToCheck[0]);
    this.personalPublic = PublicKey.fromPEM(pem: keysListToCheck[1]);
    this.messagePrivate = PrivateKey.fromPEM(pem: keysListToCheck[2]);
    this.messagePublic = PublicKey.fromPEM(pem: keysListToCheck[3]);
  }

  KeysBand.fromKeys({
    required PrivateKey personalPrivate,
    required PublicKey personalPublic,
    required PrivateKey messagePrivate,
    required PublicKey messagePublic,
  }) {
    this.personalPrivate = personalPrivate;
    this.personalPublic = personalPublic;
    this.messagePrivate = messagePrivate;
    this.messagePublic = messagePublic;
    this.multiKeyStirng = [
      personalPrivate.pem,
      personalPublic.pem,
      messagePrivate.pem,
      messagePublic.pem,
    ].join('|');
  }
}
