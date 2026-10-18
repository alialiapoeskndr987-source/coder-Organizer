import 'package:flutter/services.dart';

/// v2.0 — FLAG_SECURE gate (anti-theft hardening, D-031): while the lock
/// screen is visible the app must not appear in the app switcher or allow
/// screenshots. Implemented via a tiny MethodChannel in MainActivity.kt.
class FlagSecure {
  static const MethodChannel _channel =
      MethodChannel('com.coderorganizer/security');

  static Future<void> set(bool enabled) async {
    try {
      await _channel.invokeMethod<void>('setFlagSecure', enabled);
    } on PlatformException {
      // Older builds/platforms without the channel — fail silent.
    } on MissingPluginException {
      // Tests / non-Android platforms.
    }
  }
}
