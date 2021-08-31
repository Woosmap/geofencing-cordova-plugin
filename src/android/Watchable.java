package cordova.plugin.woosmapgeofencing;

import org.apache.cordova.CallbackContext;

public abstract class Watchable {
    public abstract void addWatch(String watchId, CallbackContext callbackContext);
    public abstract void clearWatch(String watchId);
    public boolean hasTrackingStarted=true;
}
