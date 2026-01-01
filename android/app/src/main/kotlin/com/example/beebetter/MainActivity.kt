package com.example.beebetter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Call super first to ensure FlutterActivity's default setup
        super.configureFlutterEngine(flutterEngine)
        // Explicitly register plugins to ensure they're available
        // This is critical for release builds where auto-registration may fail
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
