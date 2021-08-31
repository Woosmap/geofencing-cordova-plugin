package cordova.plugin.woosmapgeofencing;

import android.util.Log;

import com.webgeoservices.woosmapgeofencing.Woosmap;
import com.webgeoservices.woosmapgeofencing.database.Visit;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;

import java.util.HashMap;

/***
 * Implements Woosmap Visits callbacks
 */
public class WoosVisitReadyListener extends Watchable implements Woosmap.VisitReadyListener {
    private static final String TAG = "WoosVisitReadyListener";
    public static final String TYPE = "WoosVisitReadyListener";

    private HashMap<String, CallbackContext> watches = new HashMap<String, CallbackContext>();

    @Override
    public void VisitReadyCallback(Visit visit) {
        Log.d(TAG,visit.toString());
        if (hasTrackingStarted){
            sendResult(visit);
        }
    }

    @Override
    public void addWatch(String watchId, CallbackContext callbackContext) {
        watches.put(watchId,callbackContext);
    }

    @Override
    public void clearWatch(String watchId) {
        watches.remove(watchId);
    }

    private void sendResult(Visit visit){
        PluginResult pluginResult;
        JSONObject jsonObject = WoosmapUtil.getVisitObject(visit);
        for(CallbackContext callbackContext: watches.values()){
            pluginResult = new PluginResult(PluginResult.Status.OK,jsonObject);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }
    }
}
