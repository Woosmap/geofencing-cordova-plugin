package cordova.plugin.woosmapgeofencing;


import com.webgeoservices.woosmapgeofencing.Woosmap;
import com.webgeoservices.woosmapgeofencing.database.RegionLog;

import org.apache.cordova.CallbackContext;

/***
 * Implements Woosmap Region logs callbacks
 */
public class WoosRegionLogReadyListener extends Watchable implements Woosmap.RegionLogReadyListener {
    private static final String TAG = "WoosRegionLogReady";
    public static final String TYPE = "WoosRegionLogReadyListener";
    @Override
    public void RegionLogReadyCallback(RegionLog regionLog) {

    }

    @Override
    public void addWatch(String watchId, CallbackContext callbackContext) {

    }

    @Override
    public void clearWatch(String watchId) {

    }

}
