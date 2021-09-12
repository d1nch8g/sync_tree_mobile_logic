import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sync_tree_dart_crypt/sync_tree_dart_crypt.dart';

var testMarketAdress =
    '''AQIDBAUGBwgJCgsMDQ4PEBESExQVFhcYGRobHB0eHyAhIiMkJSYnKCkqKywtLi8wMTIzNDU2Nzg5Ojs8PT4/Pw==''';

var testNicotinAdress =
    '''lproB8nRtPn4kjmRQtdpongRukRgFjmNe2PXOD7mZw9JxO/by1fdGDbV1vYUX/Hzce8oF9z7rTPYa1No5ZkGwA==''';

var testAlcoholAdress =
    '''EMQqIoItMrkILx5YBJqvHRr3loDQtBIy3AURtlKE9+OLmWGvITE9wFEoMZAH/+3QyMj1iZ8qWJChuomFTSw/wg==''';

var alcoholKeys = '''-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----|-----BEGIN RSA PUBLIC KEY-----
MIICCgKCAgEAjdgFBLDvmGQvl3o87UZAxUCuGwKqym92Iv4FGujlcr95oPxkIoXt
LYnZUNXBAPdDRqeag8dhTbftCuywd99xJybV4uoqlOSghd2lu5nrtixrcIF/x3KH
+5brTzLjGaTV5WsK9hLXgnEBdPDJ6FadCo1Se8/6D5oAvKQYoqNNgZqiJBYsf9rO
0bPQqwqSaghWcfGVO/tbJY0OUfhOlhqokeGsvFa3c9g5Ca0kHvpY8u/yF33xiCl7
yadza68yxHu5X5/ciqEOldzsyK5SauyVANGHeIio5X9yVHKiEUeNLkRh3Zd1QLZv
LT6iHyBbhFzN+aI7nWUZx8mqTQPcOoJdUgXpwzsbq2ODgqZf6vLG+vonoW8A+Irt
pyP3t/SdgzwtTt9j8ssK08ma4K+mC5vHdyNt2zd0bT05ZUl2X0hGtcGgkusBmfXO
gV0CD6KynI7E25kNSFm5puCxPiZ5tisyGdrfgBM5lK8tWl5AZPBbPmNNnriUKOIr
C72EsXnxV5F3ZX626t1YUKMpfmkr9H4yicSjHYtZDVInF1VeNOW3eMUUgiw0kyEZ
ZZLQigUd1IuLkKEvoW9R1gtXKXy9e3xv8v0uhvdLL7UCEA8bDCAmzJ8fOTQLIfxe
Ad3bM7JcmnzdglKgGTQU16tIzhizQHOKGM3gNf2W1f3TJyGU8lseA50CAwEAAQ==
-----END RSA PUBLIC KEY-----|-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAsCNPGn5mU4Yd5XrFPTQfi/mWvMDH7xv7d7YANik3SjHUOG89
zW975zFtwq8TbXsmqvvwATIJ84waYKOPm6fMHtZXKxsLGZWkMPXIUFjyubnfHwOC
n/YHi2OOwBv/8VEoT7sek0zP/RgBhu1HG8NUT/mrSJOvwmMu/QYuwDYArx4GYmoz
5gUw0/3FkcV6PaknbHrAR4tTXrrM2DU31DGR/MVIShsVaDs9l1V1qzkTQX/u5zTM
1W/2YcMyC//5G2UjA3qG40ex4OzvoZVJbi/RMQWTOBI9Cb7FRxLyn5jtFDX7hiGN
EyglphweOgVb+zHAzEtemcZ6wzy50C5mgqZqdwIDAQABAoIBAQCt9gGPgh1gCssG
NY4OV6d8oMJeo+wTXUiswAVPeL+RuMsH/d5FQwFVonzsVevTKllTcEZnd9taPhpj
LceNDVnNbxZijXAWEbQ7YtQ3ftIj2s7iG55sjBqBcY+wbzcGSIiOzplxE+Er8AS6
FSkw42cnIcgogyyIyVrELdIIpo1gZZwesYWiEBCf8vkXUSrnqJezbG1ZeEW+UVwx
oLeLlrhzqtY1aNTpprdrKvPqXlelDS3Fp4M1HeHLjVM5iTbJQBIJUJz8jr5CP9dr
U+xPsXJEPWVoKGRctFSFMFzF22HW7nQ8JA+Ap76JcpZmSob7+hcgHTA5r5nWdvk1
2zSjGMJ5AoGBAN9RtKg9FoqNs/EY2I+y7VTCKTDYHomXJoJprrRxk7+TNPCyc+El
JAtTpUtGg342cFlzXe1LoTuwpz0dzQ94XJru//w1xNKePu9pG7I91v+pmZ3qscQQ
3Hfsbii96DxvV9E2UngYM/84EdmxivwgfMB0889exPbLp6x2Q4kjZkd1AoGBAMnq
CK8QOmHqP15fbBAfq/5IIyoLHSr0EsuyB+4w1Tt6Mp6JmsSj3WODcEFX6eNTDEAY
QzD6iuZt5Gumgu4u78qcVzzPQ88nyu771Z1cO7+0aHWZQnmn8tdlW8QoYe8Q0QGP
btk5Zj3IpnxcBPOAy8tEam+K/nbM6GIDoskY4Fi7AoGAEZYUnP8ajFS2a/Eh9McJ
a5hSuBb86KbvkGuUJ3+ePALys1XKTFupZ/7xUGlAJ6tP06uDJRHEo7e4o9Z59JLs
8AKMRCdT1aZCnIXxeWrnSIDpqQb3ctJFGmiTEEBMTp4SE1aszepSBfI7baJOqKZC
TMGpBZaX+jt1e95gWSdhgZUCgYBVZ/n+WsXnLtdZCtHBzDPLHiZJnWPcDFt677Yt
CVjYjKqmppvhe1Kkyi8MZKxY7ILtBZY+PGvOZkNNSaRuLUpekFzSKvWKxVEwXzOP
GTlosF3TCF226dRtScFUKqSqI5nUqCACICZgEeRiC+ZIPX12YF0JC2jxRWEyPEl5
+FzFCwKBgApQJN4uYc40vq3qiXgjUrvn5ir2Bmw9Uq139As/jBgRq2pF4mw1PsKN
fJZ1ePsMzQvSvN4o7NJyGkdH3okkkfXQyVzAJ5jEU18WsDUOZaHfrBvaDsTbm6eI
ectYiZxpZPQoSmaoltD+FcZltXU2hS1NiXe8dkg2NMzgzdD2LJvn
-----END RSA PRIVATE KEY-----|-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAsCNPGn5mU4Yd5XrFPTQfi/mWvMDH7xv7d7YANik3SjHUOG89zW97
5zFtwq8TbXsmqvvwATIJ84waYKOPm6fMHtZXKxsLGZWkMPXIUFjyubnfHwOCn/YH
i2OOwBv/8VEoT7sek0zP/RgBhu1HG8NUT/mrSJOvwmMu/QYuwDYArx4GYmoz5gUw
0/3FkcV6PaknbHrAR4tTXrrM2DU31DGR/MVIShsVaDs9l1V1qzkTQX/u5zTM1W/2
YcMyC//5G2UjA3qG40ex4OzvoZVJbi/RMQWTOBI9Cb7FRxLyn5jtFDX7hiGNEygl
phweOgVb+zHAzEtemcZ6wzy50C5mgqZqdwIDAQAB
-----END RSA PUBLIC KEY-----''';

void main() {
  test('info has trades', () async {
    var hasTrades = await infoHasTrades(
      base64.decode(testMarketAdress),
      base64.decode(testNicotinAdress),
    );
    if (hasTrades != false) {
      fail('there should not be any trades on that adress');
    }
  });
  test('info market', () async {
    var marketInfo = await infoMarket(
      base64.decode(testMarketAdress),
    );
    if (marketInfo.name != 'Bitcoin Ftem') {
      fail('the name of that market should be bitcoin ftem');
    }
  });
  test('info search', () async {
    var foundMarkets = await infoSearch('ftem');
    if (foundMarkets.length != 2) {
      fail('the length of found markets should be equal to 2');
    }
  });
  test('info user', () async {
    var userInfo = await infoUser(
      base64.decode(testAlcoholAdress),
    );
    if (userInfo.name != 'Alcohol') {
      fail('user name should be equal to Alcohol');
    }
  });
  test('info messages', () async {
    var messages = await infoMessages(
      base64.decode(testAlcoholAdress),
      base64.decode(testMarketAdress),
    );
    if (messages.length != 0) {
      fail('there should not be any messages on that user');
    }
  });
}
