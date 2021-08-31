package cordova.plugin.woosmapgeofencing;

import android.util.Log;

import com.webgeoservices.woosmapgeofencing.Woosmap;
import com.webgeoservices.woosmapgeofencing.database.POI;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;

import java.util.HashMap;

/***
 * Implements Woosmap Search API callbacks
 */
public class WoosSearchAPIReadyListener extends Watchable implements Woosmap.SearchAPIReadyListener {
    private static final String TAG = "WoosSearchAPIReady";
    public static final String TYPE = "WoosSearchAPIReadyListener";

    private HashMap<String, CallbackContext> watches = new HashMap<String, CallbackContext>();
    @Override
    public void SearchAPIReadyCallback(POI poi) {
        Log.d(TAG,poi.toString());
        if (hasTrackingStarted){
            sendResult(poi);
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

    private void sendResult(POI poi){
        PluginResult pluginResult;
        JSONObject jsonObject = WoosmapUtil.getPOIObject(poi);
        for(CallbackContext callbackContext: watches.values()){
            pluginResult = new PluginResult(PluginResult.Status.OK,jsonObject);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }
    }

}
