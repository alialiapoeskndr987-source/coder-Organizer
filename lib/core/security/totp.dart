import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// v2.0 (D-029) — RFC 6238 TOTP over RFC 4648 Base32, implemented locally
/// with package:crypto. The secret lives only in flutter_secure_storage and
/// is verified offline: no network, no server, no bot (owner decision —
/// final security design, option A).
const String _b32Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

/// Encodes bytes as unpadded uppercase Base32 (authenticator-compatible).
String base32Encode(List<int> bytes) {
  if (bytes.isEmpty) return '';
  final out = StringBuffer();
  var buffer = 0;
  var bits = 0;
  for (final b in bytes) {
    buffer = (buffer << 8) | (b & 0xff);
    bits += 8;
    while (bits >= 5) {
      out.write(_b32Alphabet[(buffer >> (bits - 5)) & 31]);
      bits -= 5;
    }
  }
  if (bits > 0) {
    out.write(_b32Alphabet[(buffer << (5 - bits)) & 31]);
  }
  return out.toString();
}

/// Decodes unpadded Base32; throws FormatException on invalid characters.
Uint8List base32Decode(String input) {
  final clean = input.toUpperCase().replaceAll('=', '').replaceAll(' ', '');
  final out = BytesBuilder();
  var buffer = 0;
  var bits = 0;
  for (final ch in clean.runes) {
    final idx = _b32Alphabet.indexOf(String.fromCharCode(ch));
    if (idx < 0) throw const FormatException('invalid base32 character');
    buffer = (buffer << 5) | idx;
    bits += 5;
    if (bits >= 8) {
      out.addByte((buffer >> (bits - 8)) & 0xff);
      bits -= 8;
    }
  }
  return out.toBytes();
}

/// Generates a 20-byte cryptographically random secret, Base32-encoded.
String generateTotpSecret() {
  final rnd = Random.secure();
  final bytes = Uint8List(20);
  for (var i = 0; i < bytes.length; i++) {
    bytes[i] = rnd.nextInt(256);
  }
  return base32Encode(bytes);
}

/// Computes the TOTP code for [secret] at [time] (RFC 6238, SHA-1, 6 digits).
String totpCode(String secret, {DateTime? time}) {
  final key = base32Decode(secret);
  var t = (time ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000 ~/ 30;
  final msg = Uint8List(8);
  for (var i = 7; i >= 0; i--) {
    msg[i] = t & 0xff;
    t >>= 8;
  }
  final h = Hmac(sha1, key).convert(msg).bytes;
  final off = h[h.length - 1] & 0x0f;
  final bin = ((h[off] & 0x7f) << 24) |
      ((h[off + 1] & 0xff) << 16) |
      ((h[off + 2] & 0xff) << 8) |
      (h[off + 3] & 0xff);
  final code = bin % 1000000;
  return code.toString().padLeft(6, '0');
}

/// Verifies [code] against [secret] accepting ±1 period (clock drift).
bool verifyTotp(String secret, String code, {DateTime? time}) {
  final now = time ?? DateTime.now();
  final trimmed = code.trim();
  for (var drift = -1; drift <= 1; drift++) {
    final expected = totpCode(
      secret,
      time: now.add(const Duration(seconds: 30) * drift),
    );
    if (_constEq(expected, trimmed)) return true;
  }
  return false;
}

/// Constant-time-ish string comparison.
bool _constEq(String a, String b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}
