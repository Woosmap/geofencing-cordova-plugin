package cordova.plugin.woosmapgeofencing;

import android.Manifest;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;

import com.webgeoservices.woosmapgeofencing.Woosmap;
import com.webgeoservices.woosmapgeofencing.WoosmapSettings;
import com.webgeoservices.woosmapgeofencing.database.Region;
import com.webgeoservices.woosmapgeofencing.database.Visit;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PermissionHelper;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import static android.content.Context.MODE_PRIVATE;

/**
 * This is a native Cordova plugin exposing Woosmap Geofencing SDK methods.
 */
public class WoosmapGeofencing extends CordovaPlugin {
    private static final String TAG = "WoosmapGeofencing";

    private static final String PERMISSION_STATUS_GRANTED_BACKGROUND = "GRANTED_BACKGROUND";
    private static final String PERMISSION_STATUS_GRANTED_FOREGROUND = "GRANTED_FOREGROUND";
    private static final String PERMISSION_STATUS_DENIED = "DENIED";
    private static final String PERMISSION_STATUS_UNKNOWN = "UNKNOWN";

    private static final String METHOD_INIT = "initialize";
    private static final String METHOD_CHECK_PERMISSIONS = "getPermissionsStatus";
    private static final String METHOD_REQUEST_PERMISSIONS = "requestPermissions";
    private static final String METHOD_WATCH_SEARCH_API = "watchSearchAPI";
    private static final String METHOD_CLEAR_SEARCH_API_WATCH = "clearSearchApiWatch";
    private static final String METHOD_WATCH_LOCATION = "watchLocation";
    private static final String METHOD_CLEAR_LOCATION_WATCH = "clearLocationWatch";
    private static final String METHOD_WATCH_DISTANCE_API = "watchDistanceApi";
    private static final String METHOD_CLEAR_DISTANCE_API_WATCH = "clearDistanceApiWatch";
    private static final String METHOD_WATCH_VISITS = "watchVisits";
    private static final String METHOD_CLEAR_VISITS_WATCH = "clearVisitsWatch";
    private static final String METHOD_WATCH_REGIONS = "watchRegions";
    private static final String METHOD_CLEAR_REGIONS_WATCH = "clearRegionsWatch";
    private static final String METHOD_GET_POIS = "getPois";
    private static final String METHOD_GET_LOCATIONS = "getLocations";
    private static final String METHOD_GET_VISITS = "getVisits";
    private static final String METHOD_GET_REGIONS = "getRegions";
    private static final String METHOD_GET_ZOIS = "getZois";
    private static final String METHOD_ADD_REGION = "addRegion";
    private static final String METHOD_REMOVE_REGION = "removeRegion";
    private static final String METHOD_DELETE_VISIT = "deleteVisit";
    private static final String METHOD_DELETE_ZOI = "deleteZoi";
    private static final String METHOD_START_TRACKING = "startTracking";
    private static final String METHOD_STOP_TRACKING = "stopTracking";
    private static final String METHOD_SEARCH_API_REQUEST = "searchAPIRequest";
    private static final String METHOD_DISTANCE_API_REQUEST = "distanceAPIRequest";
    private static final String METHOD_WATCH_AIRSHIP = "watchAirship";
    private static final String METHOD_CLEAR_AIRSHIP_WATCH = "clearAirshipWatch";
    private static final String METHOD_DELETE_LOCATION = "deleteLocation";
    private static final String METHOD_DELETE_LOCATIONS = "deleteLocations";
    private static final String METHOD_CUSTOMIZE_NOTIFICATION = "customizeNotification";
    private static final String METHOD_SET_WOOKMAP_API_KEY = "setWoosmapApiKey";
    private static final String METHOD_WATCH_MARKETING_CLOUD = "watchMarketingCloud";
    private static final String METHOD_CLEAR_MARKETING_CLOUD_WATCH = "clearMarketingCloudWatch";
    private static final String METHOD_SET_POI_RADIUS = "setPoiRadius";


    String [] foregroundLocationPermissions = { Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION};
    String [] backgroundLocationPermissions = {Manifest.permission.ACCESS_BACKGROUND_LOCATION };
    String [] allLocationPermissions = {Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_BACKGROUND_LOCATION };

    private CallbackContext callbackContext;
    private Woosmap woosmap;


    private final WoosLocationReadyListener woosLocationReadyListener = new WoosLocationReadyListener();
    private final WoosSearchAPIReadyListener woosSearchAPIReadyListener = new WoosSearchAPIReadyListener();
    private final WoosDistanceAPIReadyListener woosDistanceAPIReadyListener = new WoosDistanceAPIReadyListener();
    private final WoosVisitReadyListener woosVisitReadyListener = new WoosVisitReadyListener();
    private final WoosRegionReadyListener woosRegionReadyListener = new WoosRegionReadyListener();
    private final WoosRegionLogReadyListener woosRegionLogReadyListener = new WoosRegionLogReadyListener();
    private final WoosAirshipReadyListener woosAirshipReadyListener = new WoosAirshipReadyListener();
    private final WoosMarketingCloudListener woosMarketingCloudListener = new WoosMarketingCloudListener();

    private HashMap<String,Watchable> watchables;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        watchables = new HashMap<>();
        watchables.put(WoosLocationReadyListener.TYPE,woosLocationReadyListener);
        watchables.put(WoosSearchAPIReadyListener.TYPE,woosSearchAPIReadyListener);
        watchables.put(WoosDistanceAPIReadyListener.TYPE,woosDistanceAPIReadyListener);
        watchables.put(WoosVisitReadyListener.TYPE,woosVisitReadyListener);
        watchables.put(WoosRegionReadyListener.TYPE,woosRegionReadyListener);
        watchables.put(WoosAirshipReadyListener.TYPE,woosAirshipReadyListener);
        watchables.put(WoosMarketingCloudListener.TYPE,woosMarketingCloudListener);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;

        if (action.equals(METHOD_INIT)){
            initializeWoosmap(args);
        }
        else if (action.equals(METHOD_CHECK_PERMISSIONS)){
            getPermissionStatus();
        }
        else if (action.equals(METHOD_REQUEST_PERMISSIONS)){
            requestPermissions(args);
            return true;
        }
        else if (action.equals(METHOD_WATCH_LOCATION)){
            addWatch(WoosLocationReadyListener.TYPE,args, callbackContext);
        }
        else if (action.equals(METHOD_CLEAR_LOCATION_WATCH)){
            clearWatch(WoosLocationReadyListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_WATCH_SEARCH_API)){
            addWatch(WoosSearchAPIReadyListener.TYPE,args, callbackContext);
        }
        else if (action.equals(METHOD_CLEAR_SEARCH_API_WATCH)){
            clearWatch(WoosSearchAPIReadyListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_WATCH_DISTANCE_API)){
            addWatch(WoosDistanceAPIReadyListener.TYPE,args, callbackContext);
        }
        else if (action.equals(METHOD_CLEAR_DISTANCE_API_WATCH)){
            clearWatch(WoosDistanceAPIReadyListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_WATCH_VISITS)){
            addWatch(WoosVisitReadyListener.TYPE,args, callbackContext);
        }
        else if (action.equals(METHOD_CLEAR_VISITS_WATCH)){
            clearWatch(WoosVisitReadyListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_WATCH_REGIONS)){
            addWatch(WoosRegionReadyListener.TYPE,args, callbackContext);
        }
        else if (action.equals(METHOD_CLEAR_REGIONS_WATCH)){
            clearWatch(WoosRegionReadyListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_WATCH_AIRSHIP)){
            addWatch(WoosAirshipReadyListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_CLEAR_AIRSHIP_WATCH)){
            clearWatch(WoosAirshipReadyListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_WATCH_MARKETING_CLOUD)){
            addWatch(WoosMarketingCloudListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_CLEAR_MARKETING_CLOUD_WATCH)){
            clearWatch(WoosMarketingCloudListener.TYPE,args,callbackContext);
        }
        else if (action.equals(METHOD_GET_POIS)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                getPOIs(callbackContext);
            }
        }
        else if (action.equals(METHOD_GET_LOCATIONS)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                getLocations(callbackContext);
            }
        }
        else if (action.equals(METHOD_GET_VISITS)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                getVisits(callbackContext);
            }
        }
        else if (action.equals(METHOD_GET_REGIONS)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                getRegions(callbackContext);
            }
        }
        else if (action.equals(METHOD_GET_ZOIS)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                getZOIs(callbackContext);
            }
        }
        else if (action.equals(METHOD_ADD_REGION)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                addRegion(args,callbackContext);
            }
        }
        else if (action.equals(METHOD_REMOVE_REGION)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                removeRegion(args,callbackContext);
            }
        }
        else if (action.equals(METHOD_DELETE_VISIT)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                deleteAllVisits(callbackContext);
            }
        }
        else if (action.equals(METHOD_DELETE_ZOI)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                deleteAllZOIs(callbackContext);
            }
        }
        else if (action.equals(METHOD_DELETE_LOCATION)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                deleteLocation(args,callbackContext);
            }
        }
        else if (action.equals(METHOD_DELETE_LOCATIONS)){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                deleteLocation(args,callbackContext);
            }
        }
        else if (action.equals(METHOD_START_TRACKING)){
            startTracking(args,callbackContext);
        }
        else if (action.equals(METHOD_STOP_TRACKING)){
            stopTracking(callbackContext);
        }
        else if (action.equals(METHOD_CUSTOMIZE_NOTIFICATION)){
            customizeNotification(args,callbackContext);
        }
        else if (action.equals(METHOD_SET_WOOKMAP_API_KEY)){
            setWoosmapApiKey(args,callbackContext);
        }else if(action.equals(METHOD_SET_POI_RADIUS)){
            setPoiRadius(args);
        }
        else{
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.INVALID_ACTION,"Method not implemented");
        }
        return true;
    }

    @Override
    public void onRequestPermissionResult(int requestCode, String[] permissions, int[] grantResults) throws JSONException {
        PluginResult result;
        if(callbackContext != null) {
            for (int r : grantResults) {
                if (r == PackageManager.PERMISSION_DENIED) {
                    Log.d(TAG, "Permission Denied!");
                    WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ILLEGAL_ACCESS_EXCEPTION,"Permission Denied");
                    return;
                }

            }
            result = new PluginResult(PluginResult.Status.OK);
            callbackContext.sendPluginResult(result);
        }
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        if (woosmap!=null){
            woosmap.onResume();
        }
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        if (woosmap!=null){
            woosmap.onPause();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (woosmap!=null){
            woosmap.onDestroy();
        }
    }

    /***
     * Checks if Woosmap object is instantiated. Sends error response if object is not instantiated.
     * @param callbackContext Cordova callback context
     * @return boolean
     */
    private boolean isWoosmapInitialized(CallbackContext callbackContext){
        if (woosmap==null){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,"Woosmap not initialized");
            return false;
        }
        return true;
    }

    /***
     * Sets the Woosmap private API key for calling Woosmap APIs
     * @param args accepts Woosmap API key in a JSON array
     * @param callbackContext Cordova callback context
     */
    private void setWoosmapApiKey(JSONArray args, CallbackContext callbackContext){
        try{
            String apiKey = "";
            if (args.length()>0){
                apiKey = args.getString(0).trim();
            }
            if (!apiKey.isEmpty()){
                WoosmapSettings.privateKeyWoosmapAPI = apiKey;
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }else{
                throw new Exception("Woosmap API Key not provided");
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext, PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Customizes foreground service notification.
     * @param args Accepts JSON object with keys WoosmapNotificationChannelID, WoosmapNotificationChannelName, WoosmapNotificationDescriptionChannel
     *             updateServiceNotificationTitle, updateServiceNotificationText, WoosmapNotificationActive
     * @param callbackContext Cordova callback context
     */
    private void customizeNotification(JSONArray args, CallbackContext callbackContext){
        try{
            if (args.length()>0){
                JSONObject config = args.getJSONObject(0);
                if (config.has("WoosmapNotificationChannelID")){
                    WoosmapSettings.WoosmapNotificationChannelID = config.getString("WoosmapNotificationChannelID");
                }
                if (config.has("WoosmapNotificationChannelName")){
                    WoosmapSettings.WoosmapNotificationChannelName = config.getString("WoosmapNotificationChannelName");
                }
                if (config.has("WoosmapNotificationDescriptionChannel")){
                    WoosmapSettings.WoosmapNotificationDescriptionChannel = config.getString("WoosmapNotificationDescriptionChannel");
                }
                if (config.has("updateServiceNotificationTitle")){
                    WoosmapSettings.updateServiceNotificationTitle = config.getString("updateServiceNotificationTitle");
                }
                if (config.has("updateServiceNotificationText")){
                    WoosmapSettings.updateServiceNotificationText = config.getString("updateServiceNotificationText");
                }
                if (config.has("WoosmapNotificationActive")){
                    WoosmapSettings.WoosmapNotificationActive = config.getBoolean("WoosmapNotificationActive");
                }
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
            else{
                throw new Exception("Notification config not provided");
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext, PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Stops tracking
     * @param callbackContext Cordova callback context
     */
    private void stopTracking(CallbackContext callbackContext){
        if (isWoosmapInitialized(callbackContext)){
            woosmap.stopTracking();
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
        }
    }

    /***
     * Starts Woosmap Geofencing tracking.
     * @param args Accepts tracking profile. Value can be either liveTracking, passiveTracking or stopsTracking.
     * @param callbackContext Cordova callback context
     */
    private void startTracking(JSONArray args, CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                if (args.length()==0){
                    throw new Exception("Tracking profile is missing");
                }

                String trackingProfile = args.getString(0);
                if (trackingProfile.equals(Woosmap.ConfigurationProfile.liveTracking) ||
                        trackingProfile.equals(Woosmap.ConfigurationProfile.passiveTracking) ||
                        trackingProfile.equals(Woosmap.ConfigurationProfile.stopsTracking)){
                    woosmap.startTracking(trackingProfile);
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
                }
                else{
                    throw new Exception("Invalid tracking profile. Only possible values are liveTracking, passiveTracking, stopsTracking");
                }
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Deletes a single or all locations from database.
     * @param args Accepts location id which needs to be deleted. Deletes all locations if passed location id is empty string
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void deleteLocation(JSONArray args, CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                int locationId = -1;
                if (args.length()>0){
                    locationId = args.getInt(0);
                }
                WoosmapDbTasks.getInstance(cordova.getContext()).deleteLocation(locationId,callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Deletes all Zone of Interests from the database.
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void deleteAllZOIs(CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                WoosmapDbTasks.getInstance(cordova.getContext()).deleteAllZOIs(callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Deletes all visits from the database.
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void deleteAllVisits(CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                WoosmapDbTasks.getInstance(cordova.getContext()).deleteAllVisits(callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Deletes a single visit from the database.
     * @param args
     * @param callbackContext
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void deleteVisit(JSONArray args, CallbackContext callbackContext){
        JSONObject visitData;
        Visit visit;
        try{
            if (isWoosmapInitialized(callbackContext)){
                visitData = args.getJSONObject(0);
                visit = new Visit();
                visit.id = visitData.getInt("id");
                WoosmapDbTasks.getInstance(cordova.getContext()).deleteVisit(visit,callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Removes the region by given region id.
     * @param args JSON array which contains region id.
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void removeRegion(JSONArray args, CallbackContext callbackContext){
        JSONObject regionInfo;
        try{
            if (isWoosmapInitialized(callbackContext)){
                String regionId="";
                if (args.length()>0 && !args.isNull(0)){
                    regionInfo = args.getJSONObject(0);
                    regionId = regionInfo.has("regionId")?regionInfo.getString("regionId"):"";
                }
                WoosmapDbTasks.getInstance(cordova.getContext()).removeRegion(regionId, callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Adds/updates a region in DB as well as geofence collection
     * @param args JSON array with region detail JSON objects.
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void addRegion(JSONArray args, CallbackContext callbackContext){
        JSONObject regionInfo;
        Region region;
        try{
            if (isWoosmapInitialized(callbackContext)){
                if (args.length() == 0 || args.isNull(0)){
                    throw new Exception("regionInfo cannot be empty or null");
                }
                regionInfo = args.getJSONObject(0);
                region = new Region();
                region.identifier = regionInfo.getString("regionId");
                region.idStore = regionInfo.has("idStore")?regionInfo.getString("idStore"):"";
                region.lat = regionInfo.getDouble("lat");
                region.lng = regionInfo.getDouble("lng");
                region.radius = regionInfo.getDouble("radius");

                WoosmapDbTasks.getInstance(cordova.getContext()).addRegion(region,callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Gets all Zone of Interests from the database
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void getZOIs(CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                WoosmapDbTasks.getInstance(cordova.getContext()).enqueGetZOIsRequest(callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Gets all the regions from the database.
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void getRegions(CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                WoosmapDbTasks.getInstance(cordova.getContext()).enqueGetRegionsRequest(callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Gets all visits from the database
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void getVisits(CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                WoosmapDbTasks.getInstance(cordova.getContext()).enqueGetVisitsRequest(callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Gets all recorded locations from the database
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void getLocations(CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                WoosmapDbTasks.getInstance(cordova.getContext()).enqueGetLocationsRequest(callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Gets all Point of Interests from database
     * @param callbackContext Cordova callback context
     */
    @RequiresApi(api = Build.VERSION_CODES.N)
    private void getPOIs(CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                WoosmapDbTasks.getInstance(cordova.getContext()).enqueGetPOIsRequest(callbackContext);
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }


    /***
     * Requests permissions. If the background permission is required then ACCESS_BACKGROUND_LOCATION is requested for devices above Android 9.
     * @param args JSON Array containing a boolean parameter to check if the background permission is required
     */
    private void requestPermissions(JSONArray args){
        try{
            boolean isBackground = args.getBoolean(0);
            if (hasPermisssion(isBackground)){
                PluginResult r = new PluginResult(PluginResult.Status.OK);
                this.callbackContext.sendPluginResult(r);
            }
            else{
                if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.P){
                    PermissionHelper.requestPermissions(this, 0, foregroundLocationPermissions);
                }
                else {
                    PermissionHelper.requestPermissions(this, 0, isBackground?allLocationPermissions:foregroundLocationPermissions);
                }
            }
        }
        catch (JSONException ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Checks if the required location permissions are granted or not.
     * Returns PERMISSION_STATUS_DENIED is no permissions are granted.
     * Returns PERMISSION_STATUS_GRANTED_FOREGROUND if foreground location permission is granted.
     * Returns PERMISSION_STATUS_GRANTED_BACKGROUND if background location permission is granted.
     * Returns PERMISSION_STATUS_UNKNOWN is plugin is unable to determine.
     */
    private void getPermissionStatus(){
        String status = PERMISSION_STATUS_UNKNOWN;
        if (!hasPermisssion(false)){
            status = PERMISSION_STATUS_DENIED;
            PluginResult r = new PluginResult(PluginResult.Status.OK,status);
            this.callbackContext.sendPluginResult(r);
            return;
        }
        if (!hasPermisssion(true)){
            status = PERMISSION_STATUS_GRANTED_FOREGROUND;
            PluginResult r = new PluginResult(PluginResult.Status.OK,status);
            this.callbackContext.sendPluginResult(r);
            return;
        }
        else{
            status = PERMISSION_STATUS_GRANTED_BACKGROUND;
            PluginResult r = new PluginResult(PluginResult.Status.OK,status);
            this.callbackContext.sendPluginResult(r);
            return;
        }
    }

    /***
     * Check if the user has given location permission.
     * @param isBackground Pass true if the background permission needs to be checked.
     * @return boolean
     */
    private boolean hasPermisssion(boolean isBackground) {
        String [] locationPermissions;
        if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.P){
            locationPermissions = foregroundLocationPermissions;
        }
        else{
            locationPermissions = isBackground?backgroundLocationPermissions:foregroundLocationPermissions;
        }
        for(String p : locationPermissions){
            if(!PermissionHelper.hasPermission(this, p)){
                return false;
            }
        }
        return true;
    }

    /***
     * Initializes Woosmap object with given parameters.
     * @param args JSON array with a JSON object to instantiate the object.
     *             JSON object should have an attribute privateKeyWoosmapAPI with Woosmap API key.
     */
    private void initializeWoosmap(JSONArray args){
        PluginResult pluginResult = null;
        try{
            JSONObject config;
            String apiKey;
            String trackingProfile = "";
            if (woosmap!=null){
                pluginResult = new PluginResult(PluginResult.Status.OK);
                callbackContext.sendPluginResult(pluginResult);
                return;
            }
            else if (hasPermisssion(false)){
                config = args.getJSONObject(0);
                apiKey = config.has("privateKeyWoosmapAPI")?config.getString("privateKeyWoosmapAPI").trim():"";

                //DO not throw error even if API key is not provided
                /*if (apiKey.isEmpty()){
                    throw new Exception("Woosmap API Key not provided");
                }*/

                if (config.has("trackingProfile")){
                    if (config.getString("trackingProfile").equals(Woosmap.ConfigurationProfile.liveTracking)){
                        trackingProfile = Woosmap.ConfigurationProfile.liveTracking;
                    }else if (config.getString("trackingProfile").equals(Woosmap.ConfigurationProfile.passiveTracking)){
                        trackingProfile = Woosmap.ConfigurationProfile.passiveTracking;
                    }else if (config.getString("trackingProfile").equals(Woosmap.ConfigurationProfile.stopsTracking)){
                        trackingProfile = Woosmap.ConfigurationProfile.stopsTracking;
                    }else {
                        throw new Exception("Invalid tracking profile. Only possible values are liveTracking, passiveTracking, stopsTracking");
                    }
                }

                woosmap = Woosmap.getInstance().initializeWoosmap(cordova.getActivity().getApplicationContext());
                // Set the Delay of Duration data
                WoosmapSettings.numberOfDayDataDuration = 30;

                // Set Keys
                if (!apiKey.isEmpty()){
                    WoosmapSettings.privateKeyWoosmapAPI = apiKey;
                }

                this.woosmap.setLocationReadyListener(woosLocationReadyListener);
                this.woosmap.setSearchAPIReadyListener(woosSearchAPIReadyListener);
                this.woosmap.setDistanceAPIReadyListener(woosDistanceAPIReadyListener);
                this.woosmap.setVisitReadyListener(woosVisitReadyListener);
                this.woosmap.setRegionReadyListener(woosRegionReadyListener);
                this.woosmap.setRegionLogReadyListener(woosRegionReadyListener);

                // Airship Listener
                this.woosmap.setAirshipSearchAPIReadyListener(woosAirshipReadyListener);
                this.woosmap.setAirshipVisitReadyListener(woosAirshipReadyListener);
                this.woosmap.setAirhshipRegionLogReadyListener(woosAirshipReadyListener);

                // Marketing cloud
                this.woosmap.setMarketingCloudRegionLogReadyListener(woosMarketingCloudListener);
                this.woosmap.setMarketingCloudSearchAPIReadyListener(woosMarketingCloudListener);
                this.woosmap.setMarketingCloudVisitReadyListener(woosMarketingCloudListener);

                // For android version >= 8 you have to create a channel or use the woosmap's channel
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    this.woosmap.createWoosmapNotifChannel();
                }
                this.woosmap.onResume();

                if (!trackingProfile.isEmpty()){
                    woosmap.startTracking(trackingProfile);
                }
            }
            else{
                throw new Exception("Required permissions not granted");
            }
            pluginResult = new PluginResult(PluginResult.Status.OK);
        }
        catch (Exception ex){
            try{
                JSONObject error = new JSONObject();
                error.put("status",PluginResult.Status.ERROR.name());
                error.put("message",ex.getMessage());
                pluginResult = new PluginResult(PluginResult.Status.ERROR,error);
            }
            catch (Exception ex2){}
        }
        this.callbackContext.sendPluginResult(pluginResult);
    }

    /***
     * Adds a watch to objects in watchable collection
     * @param watchType Type of the watch to be added. Value can be either
     *                  WoosAirshipReadyListener,
     *                  WoosDistanceAPIReadyListener,
     *                  WoosLocationReadyListener,
     *                  WoosRegionReadyListener,
     *                  WoosSearchAPIReadyListener,
     *                  WoosVisitReadyListener
     * @param args A JSON array containing watch id. Returns an error response if no watch id is provided.
     * @param callbackContext Cordova callback context
     */
    private void addWatch(String watchType, JSONArray args,CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                String watchId = args.length()>0?args.getString(0):"";
                if (!watchId.isEmpty()){
                    watchables.get(watchType).addWatch(watchId,callbackContext);
                }
                else{
                    WoosmapUtil.sendErrorResponse(callbackContext, PluginResult.Status.ERROR,"Watch id cannot be empty or null");
                }
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext, PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /***
     * Removes a watch from a watchable collection
     * @param watchType Watch type. Can be any of the above.
     * @param args A JSON array containing watch id. Returns an error response if no watch id is provided.
     * @param callbackContext Cordova callback context
     */
    private void clearWatch(String watchType, JSONArray args,CallbackContext callbackContext){
        try{
            if (isWoosmapInitialized(callbackContext)){
                String watchId = args.length()>0?args.getString(0):"";
                if(!watchId.isEmpty()){
                    watchables.get(watchType).clearWatch(watchId);
                    PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, watchId);
                    callbackContext.sendPluginResult(pluginResult);
                }else {
                    WoosmapUtil.sendErrorResponse(callbackContext, PluginResult.Status.ERROR,"Watch id cannot be empty or null");
                }
            }
        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext, PluginResult.Status.ERROR,ex.getMessage());
        }
    }
    /**
     *Set radius of POI
     * @param args A JSON array containing POI radius value.
     */
    private void setPoiRadius(JSONArray args){
        try{
            if (args.length()==0){
                throw new Exception("Radius value can not be empty");
            }
            Object value=args.get(0);
            if(value instanceof Integer){
                WoosmapSettings.poiRadius=(int) value;
            }else if(value instanceof String){
                String radiusValue=(String) value;
                if(onlyContainsNumbers(radiusValue)){
                    WoosmapSettings.poiRadius=Integer.parseInt(radiusValue);
                }else {
                    WoosmapSettings.poiRadiusNameFromResponse=radiusValue;
                }
            }else {
                WoosmapUtil.sendErrorResponse(callbackContext, PluginResult.Status.ERROR,"POI Radius should be an integer or a string.");
            }

        }
        catch (Exception ex){
            WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,ex.getMessage());
        }
    }

    /**
     *
     * @param text string for checking if it contains only number or not.
     * @return true boolean value if string is only number else false.
     */
    private boolean onlyContainsNumbers(String text) {
        try {
            Long.parseLong(text);
            return true;
        } catch (NumberFormatException ex) {
            return false;
        }
    }
}
