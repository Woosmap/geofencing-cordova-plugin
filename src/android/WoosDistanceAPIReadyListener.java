package cordova.plugin.woosmapgeofencing;

import android.util.Log;

import com.webgeoservices.woosmapgeofencing.DistanceAPIDataModel.DistanceAPI;
import com.webgeoservices.woosmapgeofencing.database.Distance;
import com.webgeoservices.woosmapgeofencing.Woosmap;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;

import java.util.HashMap;

/***
 * Implements Woosmap Distance API callbacks
 */
public class WoosDistanceAPIReadyListener extends Watchable implements Woosmap.DistanceReadyListener {
    private static final String TAG = "WoosDistanceAPIReady";
        public static final String TYPE = "WoosDistanceAPIReadyListener";

    private HashMap<String, CallbackContext> watches = new HashMap<String, CallbackContext>();

    @Override
    public void DistanceReadyCallback(Distance[] distances) {
        Log.d(TAG,distances.toString());
        if (hasTrackingStarted){
            sendResult(distances);
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

    private void sendResult(Distance[] distances){
        PluginResult pluginResult;
        JSONObject jsonObject = getData(distances);
        for(CallbackContext callbackContext: watches.values()){
            pluginResult = new PluginResult(PluginResult.Status.OK,jsonObject);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }
    }

    private JSONObject getData(Distance[] distances){
        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("name", "distances");
            return jsonObject;
        }
        catch (Exception ex){
            Log.e(TAG,ex.toString());
        }
        return null;
    }
}
