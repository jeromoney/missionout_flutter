package com.beaterboofs.missionout

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


private const val CHANNEL = "poc.deeplink.flutter.dev/channel"
private val EVENTS = "poc.deeplink.flutter.dev/events"

private lateinit var startString: String
private lateinit var linksReceiver: BroadcastReceiver

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        GeneratedPluginRegistrant.registerWith(flutterEngine!!);

        val data = intent.data;
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
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action == Intent.ACTION_VIEW && ::linksReceiver.isInitialized){
            linksReceiver.onReceive(applicationContext, intent)
        }
    }

    private fun createChangeReceiver(events: EventSink) : BroadcastReceiver{
        return object : BroadcastReceiver(){
            override fun onReceive(context: Context, intent: Intent) {
                val dataString = intent.dataString
                if (dataString == null){
                    events.error("UNAVAILABLE","Link unavailable", null)
                } else {
                    events.success(dataString)
                }
            }
        }
    }

}
