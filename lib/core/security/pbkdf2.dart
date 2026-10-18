import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// v2.0 (D-028) — PBKDF2-HMAC-SHA256 key derivation (RFC 2898).
/// Implemented on top of package:crypto to keep the dependency set
/// minimal and platform-independent. Used for the app password: the
/// plaintext never leaves this module; only salt/hash live in
/// flutter_secure_storage.
Uint8List pbkdf2HmacSha256(
  String password,
  List<int> salt,
  int iterations,
  int keyLength,
) {
  final pwBytes = utf8.encode(password);
  final hmac = Hmac(sha256, pwBytes);
  final blocks = (keyLength / 32).ceil();
  final out = Uint8List(keyLength);
  var offset = 0;

  for (var block = 1; block <= blocks; block++) {
    // U1 = PRF(P, S || INT_32_BE(block))
    final input = Uint8List(salt.length + 4)
      ..setRange(0, salt.length, salt);
    input[salt.length] = (block >> 24) & 0xff;
    input[salt.length + 1] = (block >> 16) & 0xff;
    input[salt.length + 2] = (block >> 8) & 0xff;
    input[salt.length + 3] = block & 0xff;

    var u = Uint8List.fromList(hmac.convert(input).bytes);
    final t = Uint8List.fromList(u);
    for (var i = 1; i < iterations; i++) {
      u = Uint8List.fromList(hmac.convert(u).bytes);
      for (var j = 0; j < t.length; j++) {
        t[j] ^= u[j];
      }
    }
    final take =
        (keyLength - offset) < t.length ? (keyLength - offset) : t.length;
    out.setRange(offset, offset + take, t);
    offset += take;
  }
  return out;
}
