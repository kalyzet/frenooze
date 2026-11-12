package com.kalyzet.frenooze

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.kalyzet.frenooze.platform.AndroidPlatformApi
import com.kalyzet.frenooze.platform.AndroidPlatformApiImpl

class MainActivity : FlutterActivity() {
    private lateinit var platformApi: AndroidPlatformApiImpl

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        platformApi = AndroidPlatformApiImpl(applicationContext)
        platformApi.attachScreenHandlers(
            keepScreenOn = {
                window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            },
            releaseScreenOn = {
                window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            },
        )
        AndroidPlatformApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            platformApi,
        )
    }

    override fun onDestroy() {
        // Never leave the screen forced on or the vibrator running after the
        // activity goes away (PRD §4.4.4: closing stops everything).
        if (::platformApi.isInitialized) {
            platformApi.stopVibration()
            platformApi.releaseScreenOn()
        }
        super.onDestroy()
    }
}
