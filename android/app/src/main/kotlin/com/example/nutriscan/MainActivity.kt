package com.example.nutriscan


import android.app.AlarmManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val CHANNEL = "alarm_permission_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "canScheduleExactAlarms") {
                    val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        result.success(alarmManager.canScheduleExactAlarms())
                    } else {
                        result.success(true) // No necesario en Android 11 o menor
                    }
                } else {
                    result.notImplemented()
                }
            }
    }



}
