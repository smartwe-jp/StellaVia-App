package com.fund.stellavia

import android.app.NotificationManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onResume() {
        super.onResume()
        clearNotifications()
    }

    private fun clearNotifications() {
        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
        notificationManager?.cancelAll()
    }
}
