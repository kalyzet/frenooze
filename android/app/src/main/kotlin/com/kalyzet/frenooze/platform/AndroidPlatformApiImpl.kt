package com.kalyzet.frenooze.platform

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.Settings
import android.os.SystemClock
import java.time.ZoneId
import java.time.ZonedDateTime

class AndroidPlatformApiImpl(private val context: Context) : AndroidPlatformApi {

    override fun getDeviceTimezone(): DeviceTimezone {
        val zone = ZoneId.systemDefault()
        val offsetMinutes = ZonedDateTime.now(zone).offset.totalSeconds / 60
        return DeviceTimezone(zone.id, offsetMinutes.toLong())
    }

    override fun getElapsedRealtimeMs(): Long {
        return SystemClock.elapsedRealtime()
    }

    override fun getBootCount(): Long {
        return try {
            Settings.Global.getInt(context.contentResolver, Settings.Global.BOOT_COUNT, 0).toLong()
        } catch (e: Exception) {
            0L
        }
    }

    // --- Wake-up Mode (PRD §4.4) ------------------------------------------

    private val vibrator: Vibrator?
        get() = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val manager =
                context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
            manager?.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        }

    override fun startVibration() {
        val target = vibrator ?: return
        if (!target.hasVibrator()) return

        // Repeating burst-with-pause pattern (PRD §4.4.2): a clear but not
        // harsh double tap followed by a short rest, driven entirely by the
        // vibrator hardware so no Dart loop keeps the CPU awake.
        val timings = longArrayOf(0, 450, 250, 450, 900)
        val amplitudes = intArrayOf(0, 180, 0, 255, 0)
        val effect = VibrationEffect.createWaveform(timings, amplitudes, 1)
        target.vibrate(effect)
    }

    override fun stopVibration() {
        vibrator?.cancel()
    }

    // Screen keep-on lives on the Activity window, so MainActivity installs
    // the window-dependent half through [attachActivityWindow].
    private var screenOnController: (() -> Unit)? = null
    private var screenOffController: (() -> Unit)? = null

    fun attachScreenHandlers(
        keepScreenOn: () -> Unit,
        releaseScreenOn: () -> Unit,
    ) {
        screenOnController = keepScreenOn
        screenOffController = releaseScreenOn
    }

    override fun keepScreenOn() {
        screenOnController?.invoke()
    }

    override fun releaseScreenOn() {
        screenOffController?.invoke()
    }
}
