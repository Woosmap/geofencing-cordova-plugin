package cordova.plugin.woosmapgeofencing;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.webgeoservices.woosmapgeofencing.WoosmapRebootJobService;

/***
 * Boot Receiver to start Woosmap service.
 */
public class RunOnStartup extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if ("android.intent.action.BOOT_COMPLETED".equals(intent.getAction())) {
            WoosmapRebootJobService.enqueueWork(context, new Intent());
        }
    }
}
