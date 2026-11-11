package com.kalyzet.frenooze

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.kalyzet.frenooze.platform.AndroidPlatformApi
import com.kalyzet.frenooze.platform.AndroidPlatformApiImpl

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AndroidPlatformApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            AndroidPlatformApiImpl(applicationContext),
        )
    }
}