package cordova.plugin.woosmapgeofencing;

import com.webgeoservices.woosmapgeofencing.Woosmap;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;

import java.util.HashMap;

public class WoosMarketingCloudListener extends Watchable implements Woosmap.MarketingCloudRegionLogReadyListener, Woosmap.MarketingCloudVisitReadyListener, Woosmap.MarketingCloudSearchAPIReadyListener {

    private static final String TAG = "WoosMarketingCloudListen";
    public static final String TYPE = "WoosMarketingCloudListener";

    private HashMap<String, CallbackContext> watches = new HashMap<String, CallbackContext>();

    @Override
    public void addWatch(String watchId, CallbackContext callbackContext) {
        watches.put(watchId,callbackContext);
    }

    @Override
    public void clearWatch(String watchId) {
        watches.remove(watchId);
    }

    @Override
    public void MarketingCloudRegionLogReadyCallback(HashMap<String, Object> hashMap) {
        if (hasTrackingStarted){
            sendResult(hashMap);
        }
    }

    @Override
    public void MarketingCloudSearchAPIReadyCallback(HashMap<String, Object> hashMap) {
        if (hasTrackingStarted){
            sendResult(hashMap);
        }
    }

    @Override
    public void MarketingCloudVisitReadyCallback(HashMap<String, Object> hashMap) {
        if (hasTrackingStarted){
            sendResult(hashMap);
        }
    }

    private void sendResult(HashMap<String, Object> eventData){
        PluginResult pluginResult;
        try{
            JSONObject jsonObject = WoosmapUtil.getAirshipEventData(eventData);
            for(CallbackContext callbackContext: watches.values()){
                pluginResult = new PluginResult(PluginResult.Status.OK,jsonObject);
                pluginResult.setKeepCallback(true);
                callbackContext.sendPluginResult(pluginResult);
            }
        }
        catch (Exception ex){
            for(CallbackContext callbackContext: watches.values()){
                WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage(),true);
            }
        }
    }
}
