package cordova.plugin.woosmapgeofencing;

import android.location.Location;
import android.util.Log;

import com.google.gson.Gson;
import com.webgeoservices.woosmapgeofencing.database.MovingPosition;
import com.webgeoservices.woosmapgeofencing.database.POI;
import com.webgeoservices.woosmapgeofencing.database.Region;
import com.webgeoservices.woosmapgeofencing.database.Visit;
import com.webgeoservices.woosmapgeofencing.database.ZOI;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/***
 * Contains misc. utility functions.
 */
public class WoosmapUtil {
    private static final String TAG="WoosmapUtil";
    public static JSONObject getLocationObject(Location location){
        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("latitude", location.getLatitude());
            jsonObject.put("longitude", location.getLongitude());
            jsonObject.put("locationid", "1");
            jsonObject.put("locationdescription", "description");
            jsonObject.put("date", location.getTime());

            return jsonObject;
        }
        catch (Exception ex){
            Log.e(TAG,ex.toString());
        }
        return null;
    }
    public static JSONObject getMovingPositionObject(MovingPosition location){
        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("latitude", location.lat);
            jsonObject.put("longitude", location.lng);
            jsonObject.put("locationid", location.id);
            jsonObject.put("locationdescription", "description");
            jsonObject.put("date", location.dateTime);
            return jsonObject;
        }
        catch (Exception ex){
            Log.e(TAG,ex.toString());
        }
        return null;
    }
    public static JSONObject getRegionObject(Region region){
        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("longitude", region.lng);
            jsonObject.put("latitude", region.lat);
            jsonObject.put("date", region.dateTime);
            jsonObject.put("didenter", region.didEnter);
            jsonObject.put("identifier", region.identifier);
            jsonObject.put("radius", region.radius);
            jsonObject.put("frompositiondetection", region.isCurrentPositionInside);
            return jsonObject;
        }
        catch (Exception ex){
            Log.e(TAG,ex.toString());
        }
        return null;
    }
    public static JSONObject getPOIObject(POI poi){
        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("date", poi.dateTime);
            jsonObject.put("distance", poi.distance);
            jsonObject.put("locationid", poi.locationId);
            jsonObject.put("latitude", poi.lat);
            jsonObject.put("longitude", poi.lng);
            jsonObject.put("city", poi.city);
            jsonObject.put("idstore", poi.idStore);
            jsonObject.put("name", poi.name);
            jsonObject.put("duration", poi.duration);
            jsonObject.put("zipcode", poi.zipCode);
            jsonObject.put("jsondata", poi.data);
            return jsonObject;
        }
        catch (Exception ex){
            Log.e(TAG,ex.toString());
        }
        return null;
    }

    public static JSONObject getVisitObject(Visit visit){
        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("id",visit.id);
            jsonObject.put("accuracy",visit.accuracy);
            jsonObject.put("arrivaldate",visit.startTime);
            jsonObject.put("departuredate",visit.endTime);
            jsonObject.put("latitude",visit.lat);
            jsonObject.put("longitude",visit.lng);
            return jsonObject;
        }
        catch (Exception ex){
            Log.e(TAG,ex.toString());
        }
        return null;
    }

    public static JSONObject getZOIObject(ZOI zoi){
        JSONArray subarrays;
        String serializedValue = "";
        Gson gson = new Gson();

        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("accumulator",zoi.accumulator);
            jsonObject.put("age",zoi.age);
            jsonObject.put("covariance_det",zoi.covariance_det);
            jsonObject.put("duration",zoi.duration);
            jsonObject.put("endtime",zoi.endTime);


            serializedValue = gson.toJson(zoi.idVisits);
            subarrays = new JSONArray(serializedValue);
            jsonObject.put("idvisits",subarrays);

            jsonObject.put("latmean",zoi.latMean);
            jsonObject.put("lngmean",zoi.lngMean);
            jsonObject.put("period",zoi.period);
            jsonObject.put("prior_probability",zoi.prior_probability);
            jsonObject.put("starttime",zoi.startTime);

            serializedValue = gson.toJson(zoi.weekly_density);
            subarrays = new JSONArray(serializedValue);
            jsonObject.put("weekly_density",subarrays);

            jsonObject.put("wktpolygon",zoi.wktPolygon);
            jsonObject.put("x00covariance_matrix_inverse",zoi.x00Covariance_matrix_inverse);
            jsonObject.put("x01covariance_matrix_inverse",zoi.x01Covariance_matrix_inverse);
            jsonObject.put("x10covariance_matrix_inverse",zoi.x10Covariance_matrix_inverse);
            jsonObject.put("x11covariance_matrix_inverse",zoi.x11Covariance_matrix_inverse);
            return jsonObject;
        }
        catch (Exception ex){
            Log.e(TAG,ex.toString());
        }
        return null;
    }

    public static void sendErrorResponse(CallbackContext callbackContext, PluginResult.Status status, String message){
        PluginResult pluginResult = new PluginResult(status);
        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("status", status.name());
            jsonObject.put("message", message);
            pluginResult = new PluginResult(status, jsonObject);

            callbackContext.sendPluginResult(pluginResult);
        }
        catch (Exception ex){
            callbackContext.sendPluginResult(pluginResult);
        }
    }

    public static void sendErrorResponse(CallbackContext callbackContext, PluginResult.Status status, String message, boolean keepCallbackContext){
        PluginResult pluginResult = new PluginResult(status);
        try{
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("status", status.name());
            jsonObject.put("message", message);
            pluginResult = new PluginResult(status, jsonObject);
            pluginResult.setKeepCallback(keepCallbackContext);
            callbackContext.sendPluginResult(pluginResult);
        }
        catch (Exception ex){
            callbackContext.sendPluginResult(pluginResult);
        }
    }

    public static JSONObject getAirshipEventData(HashMap<String, Object> eventData) throws Exception{
        JSONObject object = new JSONObject();
        JSONObject properties = new JSONObject();
        if (eventData.containsKey("event")){
            object.put("name",eventData.get("event").toString());
        }
        for(Map.Entry<String,Object> entry: eventData.entrySet()){
            properties.put(entry.getKey(),entry.getValue().toString());
        }
        object.put("properties",properties);
        return object;
    }
}
