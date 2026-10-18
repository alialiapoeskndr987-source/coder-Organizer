package com.coderorganizer.coder_organizer

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// v2.0 — hosts the FLAG_SECURE channel (D-031): while the lock screen is
/// visible the app must not appear in the app switcher nor allow screenshots.
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.coderorganizer/security")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setFlagSecure" -> {
                        val enable = call.arguments as? Boolean ?: false
                        runOnUiThread {
                            if (enable) {
                                window.attributes.flags = window.attributes.flags or
                                    WindowManager.LayoutParams.FLAG_SECURE
                            } else {
                                window.attributes.flags = window.attributes.flags and
                                    WindowManager.LayoutParams.FLAG_SECURE.inv()
                            }
                            window.attributes = window.attributes
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
