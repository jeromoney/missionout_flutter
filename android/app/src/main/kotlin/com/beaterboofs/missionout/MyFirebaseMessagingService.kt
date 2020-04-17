package com.beaterboofs.missionout

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

@SuppressLint("MissingFirebaseInstanceTokenRefresh") // Handled in flutter code
class MyFirebaseMessagingService : FirebaseMessagingService() {
    private val CHANNEL_ID = "1234"
    private val CHANNEL_NAME = "Mission Pages"

    private fun createNotificationChannel(): NotificationManager? {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val defaultSoundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE+ "://"+ getApplicationContext().getPackageName() + "/" + R.raw.school_fire_alarm)
            val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_UNKNOWN)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .build()
            val channel: NotificationChannel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_HIGH).apply {
                lightColor = Color.GRAY
                enableLights(true)
                name = "MissionOut Pages"
                description = "Page Channel"
                importance = NotificationManager.IMPORTANCE_HIGH
                setSound(defaultSoundUri, audioAttributes)
            }
            notificationManager.createNotificationChannel(channel)
            return notificationManager


        } else {
            return null
        }
    }

    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        // Uh Oh -- FCM received so there must be a mission.
        // Display a notification, play sound and allow user to dismiss sound
        val notificationManager = createNotificationChannel()

        val header = message.data["description"]
        val body = message.data["action"]
        val path = message.data["path"]
        val notificationId = 12344
        // Create an explicit intent for an Activity in your app
        // TODO - create deep link to detail page. This existing method is causing it to crash
        val uri = "poc://deeplink.flutter.dev/someparam"

        val notificationIntent = Intent(Intent.ACTION_VIEW, Uri.parse(uri))
        val pendingIntent = PendingIntent.getActivity(baseContext, 0, notificationIntent, 0)

        //val notificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        // play sound
        //val defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
//        val defaultSoundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE+ "://"+ getApplicationContext().getPackageName() + "/" + R.raw.school_fire_alarm)
//        val channel: NotificationChannel
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_HIGH).apply {
//                lightColor = Color.GRAY
//                enableLights(true)
//
//                description = "Page Channel"
//            }
//            val audioAttributes = AudioAttributes.Builder()
//                    .setContentType(AudioAttributes.CONTENT_TYPE_UNKNOWN)
//                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
//                    .build()
//            channel.setSound(defaultSoundUri, audioAttributes)
//            notificationManager.createNotificationChannel(channel)
//        }

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.drawable.notification_logo)
                .setContentTitle(header)
                .setContentText(body)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(pendingIntent)
                .setDeleteIntent(pendingIntent)
                .setSmallIcon(R.drawable.notification_logo)
                .build()

        notificationManager!!.notify(notificationId, notification)
        // show notification
//        with(NotificationManagerCompat.from(this)) {
//            // notificationId is a unique int for each notification that you must define
//            notify(notificationId, builder.build())
//        }
    }
}