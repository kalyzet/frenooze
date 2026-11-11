package com.kalyzet.frenooze.platform

import android.content.Context
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
}