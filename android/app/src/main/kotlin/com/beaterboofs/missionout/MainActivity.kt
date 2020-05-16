package com.beaterboofs.missionout

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import android.net.Uri
import android.media.AudioAttributes
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationChannelGroup
import androidx.annotation.RequiresApi


private const val CHANNEL = "poc.deeplink.flutter.dev/channel"
private val EVENTS = "poc.deeplink.flutter.dev/events"

private lateinit var startString: String
private lateinit var linksReceiver: BroadcastReceiver

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "missionoutAndroid").setMethodCallHandler{
            call, result ->
            if (call.method == "createChannel") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val groupId: String? = call.argument("groupId") // the id of the group you want the channel to be created
                    val id: String? = call.argument("id") // the id of the channel
                    val name: String? = call.argument("name") // the name of the channel to be seen by the user within the notification settings
                    val description: String? = call.argument("description") // optional description to go along with the name
                    val soundName: String? = call.argument("sound") // reference to the file name you want to attach to the channel
                    deleteChannel(id) // we do this to delete the former settings in order to change the sound if needed, if there's no channel by this id, nothing will happen

                    val sound = getSound(soundName) // get the corresponding sound Uri, see further on in the getSound method
                    val audioAttributes = AudioAttributes.Builder() // declare the AudioAttributes
                            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                            .build()

                    val mChannel = NotificationChannel(id, name,
                            NotificationManager.IMPORTANCE_DEFAULT) // create the actual channel
                    mChannel.setDescription(description) // add the description if set
                    mChannel.setSound(sound, audioAttributes) // add the sound for this channel
                    mChannel.setGroup(groupId) // set the group for this channel, make sure the group is created in an earlier call

                    val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
                    notificationManager.createNotificationChannel(mChannel) // attach the channel to the notificationManager

                    result.success("Notification channel $name with sound $soundName created") // result is given back to the flutter call
                } else {
                    // No-op
                    result.success("Android version is less than Oreo")
                }
            } else if (call.method == "deleteChannel") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val id: String? = call.argument("id") // get the id of the channel to be deleted
                    deleteChannel(id) // call the method to delete the channel
                    result.success("Channel with id $id deleted")
                } else {
                    // No-op
                    result.success("Android version is less than Oreo")
                }
            } else if (call.method == "deleteChannelGroup") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val groupId: String? = call.argument("groupId") // id of the channelgroup to be deleted, if there are channels within this group, they will be deleted as well
                    deleteGroup(groupId) // call the method to delete the channelgroup
                    result.success("Group with id $groupId deleted")
                } else {
                    // No-op
                    result.success("Android version is less than Oreo")
                }
            } else if (call.method == "createChannelGroup") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val groupId: String? = call.argument("groupId") // id of the channelgroup you want to create
                    val groupName: String? = call.argument("groupName") // name for the channelgroup to be seen within the notification settings
                    createGroup(groupId, groupName) // call the method to create the channelgroup
                    result.success("Group with name $groupName created")
                } else {
                    // No-op
                    result.success("Android version is less than Oreo")
                } // return} result
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        


        GeneratedPluginRegistrant.registerWith(flutterEngine!!)

        val data = intent.data
        val flutterView = io.flutter.view.FlutterView(context)



        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result
            ->
            if (call.method == "initialLink") {
                if (!::startString.isInitialized) {
                    result.success(startString)
                }
            }
        }

        EventChannel(flutterView, EVENTS).setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any, events: EventSink) {
                        linksReceiver = createChangeReceiver(events)
                    }

                    override fun onCancel(args: Any) {
                        unregisterReceiver(linksReceiver) // code in tutorial is different linksReceiver = null. not sure why
                    }
                }
        )


        if (data != null) {
            startString = data.toString()
            if (::linksReceiver.isInitialized) {
                linksReceiver.onReceive(this.applicationContext, intent)
            }
        }


        MethodChannel(flutterView, "missionoutAndroid").setMethodCallHandler { // nl.sobit is the communication channel between flutter and kotlin and can be anything you want as long as it is unique
            call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "createChannel") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val groupId: String? = call.argument("groupId") // the id of the group you want the channel to be created
                    val id: String? = call.argument("id") // the id of the channel
                    val name: String? = call.argument("name") // the name of the channel to be seen by the user within the notification settings
                    val description: String? = call.argument("description") // optional description to go along with the name
                    val soundName: String? = call.argument("sound") // reference to the file name you want to attach to the channel
                    deleteChannel(id) // we do this to delete the former settings in order to change the sound if needed, if there's no channel by this id, nothing will happen

                    val sound = getSound(soundName) // get the corresponding sound Uri, see further on in the getSound method
                    val audioAttributes = AudioAttributes.Builder() // declare the AudioAttributes
                            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                            .build()

                    val mChannel = NotificationChannel(id, name,
                            NotificationManager.IMPORTANCE_DEFAULT) // create the actual channel
                    mChannel.setDescription(description) // add the description if set
                    mChannel.setSound(sound, audioAttributes) // add the sound for this channel
                    mChannel.setGroup(groupId) // set the group for this channel, make sure the group is created in an earlier call

                    val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
                    notificationManager.createNotificationChannel(mChannel) // attach the channel to the notificationManager

                    result.success("Notification channel $name with sound $soundName created") // result is given back to the flutter call
                } else {
                    // No-op
                    result.success("Android version is less than Oreo")
                }
            } else if (call.method == "deleteChannel") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val id: String? = call.argument("id") // get the id of the channel to be deleted
                    deleteChannel(id) // call the method to delete the channel
                    result.success("Channel with id $id deleted")
                } else {
                    // No-op
                    result.success("Android version is less than Oreo")
                }
            } else if (call.method == "deleteChannelGroup") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val groupId: String? = call.argument("groupId") // id of the channelgroup to be deleted, if there are channels within this group, they will be deleted as well
                    deleteGroup(groupId) // call the method to delete the channelgroup
                    result.success("Group with id $groupId deleted")
                } else {
                    // No-op
                    result.success("Android version is less than Oreo")
                }
            } else if (call.method == "createChannelGroup") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val groupId: String? = call.argument("groupId") // id of the channelgroup you want to create
                    val groupName: String? = call.argument("groupName") // name for the channelgroup to be seen within the notification settings
                    createGroup(groupId, groupName) // call the method to create the channelgroup
                    result.success("Group with name $groupName created")
                } else {
                    // No-op
                    result.success("Android version is less than Oreo")
                } // return} result
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action == Intent.ACTION_VIEW && ::linksReceiver.isInitialized) {
            linksReceiver.onReceive(applicationContext, intent)
        }
    }

    private fun createChangeReceiver(events: EventSink): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val dataString = intent.dataString
                if (dataString == null) {
                    events.error("UNAVAILABLE", "Link unavailable", null)
                } else {
                    events.success(dataString)
                }
            }
        }
    }

    private fun createGroup(groupId: String?, groupName: String?) { // create a channelgroup
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannelGroup(NotificationChannelGroup(groupId, groupName))
        }
    }

    private fun deleteGroup(groupId: String?) { // delete a channelgroup
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.deleteNotificationChannelGroup(groupId)
        }
    }

    private fun deleteChannel(id: String?) { // delete a channel
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.deleteNotificationChannel(id)
        }
    }

    private fun getSound(soundName: String?): Uri { // get the sound Uri
        return when (soundName) {
            "concise" -> Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.school_fire_alarm) // the concise file sound
            "light" -> Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.school_fire_alarm) // the light file sound
            "plucky" -> Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.school_fire_alarm) // the pluck file sound
            "tasty" -> Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.school_fire_alarm) // the tasty file sound

            else -> Uri.parse("android.resource://" + getPackageName() + "/" + R.raw.school_fire_alarm) // if the when statement couldn't find the corresponding item this one will be returned
        }

    }
}