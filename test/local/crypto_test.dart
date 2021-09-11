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
}
