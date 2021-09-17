package cordova.plugin.woosmapgeofencing;

import android.util.Log;

import com.webgeoservices.woosmapgeofencing.Woosmap;
import com.webgeoservices.woosmapgeofencing.database.Region;
import com.webgeoservices.woosmapgeofencing.database.RegionLog;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;

import java.util.HashMap;

/***
 * Implements Woosmap Region callbacks
 */
public class WoosRegionReadyListener extends Watchable implements Woosmap.RegionReadyListener, Woosmap.RegionLogReadyListener {
    private static final String TAG = "WoosRegionReadyListener";
    public static final String TYPE = "WoosRegionReadyListener";

    private HashMap<String, CallbackContext> watches = new HashMap<String, CallbackContext>();

    @Override
    public void RegionReadyCallback(Region region) {
        Log.d(TAG,region.toString());
        if (hasTrackingStarted){
            JSONObject jsonObject = WoosmapUtil.getRegionObject(region);
            sendResult(jsonObject);
        }
    }

    @Override
    public void RegionLogReadyCallback(RegionLog regionLog) {
        if (hasTrackingStarted){
            JSONObject jsonObject = WoosmapUtil.getRegionObject(regionLog);
            sendResult(jsonObject);
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

    private void sendResult(JSONObject region){
        PluginResult pluginResult;
        for(CallbackContext callbackContext: watches.values()){
            pluginResult = new PluginResult(PluginResult.Status.OK,region);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }
    }

}
