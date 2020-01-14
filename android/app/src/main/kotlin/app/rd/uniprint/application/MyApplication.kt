package app.rd.uniprint.application

import android.content.Context
import androidx.multidex.MultiDex
//import be.tramckrijte.workmanager.WorkmanagerPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;


class MyApplication : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun registerWith(p0: PluginRegistry?) {
        GeneratedPluginRegistrant.registerWith(p0);
    }

    override fun onCreate() {
        super.onCreate()
        //WorkmanagerPlugin.setPluginRegistrantCallback(this)
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}