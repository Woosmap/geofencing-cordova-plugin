package cordova.plugin.woosmapgeofencing;

import android.location.Location;
import android.util.Log;

import com.webgeoservices.woosmapgeofencing.Woosmap;
import com.webgeoservices.woosmapgeofencing.database.WoosmapDb;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;

import java.util.HashMap;

/***
 * Implements Woosmap Location Ready callbacks
 */
public class WoosLocationReadyListener extends Watchable implements Woosmap.LocationReadyListener {
    private static final String TAG = "WoosLocationReadyListen";
    public static final String TYPE = "WoosLocationReadyListener";

    private HashMap<String, CallbackContext> watches = new HashMap<String, CallbackContext>();

    @Override
    public void LocationReadyCallback(Location location) {
        Log.d(TAG,location.toString());
        if (hasTrackingStarted){
            sendResult(location);
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

    private void sendResult(Location location){
        PluginResult pluginResult;
        JSONObject jsonObject = WoosmapUtil.getLocationObject(location);
        for(CallbackContext callbackContext: watches.values()){
            pluginResult = new PluginResult(PluginResult.Status.OK,jsonObject);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }
    }

}
