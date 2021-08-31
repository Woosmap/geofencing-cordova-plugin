package cordova.plugin.woosmapgeofencing;

import android.content.Context;
import android.location.Location;
import android.os.Build;

import androidx.annotation.RequiresApi;

import com.google.android.gms.maps.model.LatLng;
import com.google.gson.Gson;
import com.webgeoservices.woosmapgeofencing.PositionsManager;
import com.webgeoservices.woosmapgeofencing.Woosmap;
import com.webgeoservices.woosmapgeofencing.database.MovingPosition;
import com.webgeoservices.woosmapgeofencing.database.POI;
import com.webgeoservices.woosmapgeofencing.database.Region;
import com.webgeoservices.woosmapgeofencing.database.Visit;
import com.webgeoservices.woosmapgeofencing.database.WoosmapDb;
import com.webgeoservices.woosmapgeofencing.database.ZOI;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;
import java.util.function.BiConsumer;
import java.util.function.Supplier;

/***
 * Contains all the database related helper methods with run on the background thread.
 */
public class WoosmapDbTasks {
    private static WoosmapDbTasks _instance=null;

    private List<CallbackContext> getPOIsCallbackContexts;
    private boolean isPOIFetchTaskRunning = false;

    private List<CallbackContext> getLocationsCallbackContexts;
    private boolean isLocationsFetchTaskRunning = false;

    private List<CallbackContext> getVisitsTaskCallbackContexts;
    private boolean isVisitsFetchTaskRunning = false;

    private List<CallbackContext> getRegionsTaskCallbackContexts;
    private boolean isRegionsFetchTaskRunning = false;

    private List<CallbackContext> getZOIsTaskCallbackContexts;
    private boolean isZOIsFetchTaskRunning = false;

    private final Context context;

    private WoosmapDbTasks(Context context){
        getPOIsCallbackContexts = new ArrayList<>();
        getLocationsCallbackContexts = new ArrayList<>();
        getVisitsTaskCallbackContexts = new ArrayList<>();
        getRegionsTaskCallbackContexts = new ArrayList<>();
        getZOIsTaskCallbackContexts = new ArrayList<>();
        this.context = context;
    }

    public static WoosmapDbTasks getInstance(Context context){
        if (_instance == null){
            _instance = new WoosmapDbTasks(context);
        }
        return _instance;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void deleteLocation(final int locationId, final CallbackContext callbackContext){
        CompletableFuture.supplyAsync((Supplier<Void>) () -> {
            try{
                if (locationId!=-1){
                    MovingPosition movingPosition = new MovingPosition();
                    movingPosition.id = locationId;
                    WoosmapDb.getInstance(context).getMovingPositionsDao().deleteMovingPosition(movingPosition);
                }
                else {
                    WoosmapDb.getInstance(context).getMovingPositionsDao().deleteAllMovingPositions();
                }
            }
            catch (Exception ex){
                throw new CompletionException(ex);
            }
            return null;
        }).whenComplete((unused, throwable) -> {
            if (throwable!=null){
                WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,throwable.getMessage());
            }
            else{
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK,"Deleted"));
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void deleteAllZOIs(final CallbackContext callbackContext){
        CompletableFuture.supplyAsync((Supplier<Void>) () -> {
            try{
                WoosmapDb.getInstance(context).getZOIsDAO().deleteAllZOI();
            }
            catch (Exception ex){
                throw new CompletionException(ex);
            }
            return null;
        }).whenComplete((unused, throwable) -> {
            if (throwable!=null){
                WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,throwable.getMessage());
            }
            else{
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK,"Deleted"));
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void deleteAllVisits(final CallbackContext callbackContext){
        CompletableFuture.supplyAsync((Supplier<Void>) () -> {
            try{
                WoosmapDb.getInstance(context).getVisitsDao().deleteAllStaticPositions();
            }
            catch (Exception ex){
                throw new CompletionException(ex);
            }
            return null;
        }).whenComplete((unused, throwable) -> {
            if (throwable!=null){
                WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,throwable.getMessage());
            }
            else{
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK,"Deleted"));
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void deleteVisit(final Visit visit, final CallbackContext callbackContext){
        CompletableFuture.supplyAsync((Supplier<Void>) () -> {
            try{
                WoosmapDb.getInstance(context).getVisitsDao().deleteStaticPositions(visit);
            }
            catch (Exception ex){
                throw new CompletionException(ex);
            }
            return null;
        }).whenComplete((unused, throwable) -> {
            if (throwable!=null){
                WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,throwable.getMessage());
            }
            else{
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK,"Deleted"));
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void removeRegion(String regionId, final CallbackContext callbackContext){
        CompletableFuture.supplyAsync((Supplier<Void>) () -> {
            try{
                if (!regionId.isEmpty()){
                    Woosmap.getInstance().removeGeofence(regionId);
                }
                else{
                    Woosmap.getInstance().removeGeofence();
                    WoosmapDb.getInstance(context).getRegionsDAO().deleteAllRegions();
                }
            }
            catch (Exception ex){
                throw new CompletionException(ex);
            }
            return null;
        }).whenComplete((unused, throwable) -> {
            if (throwable!=null){
                WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,throwable.getMessage());
            }
            else{
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void addRegion(final Region region, final CallbackContext callbackContext){
        CompletableFuture.supplyAsync((Supplier<Void>) () -> {
            try{
                Woosmap.getInstance().addGeofence(region.identifier,new LatLng(region.lat,region.lng), (float)region.radius, region.idStore);
            }
            catch (Exception ex){
                throw new CompletionException(ex);
            }
            return null;
        }).whenComplete((unused, throwable) -> {
            if (throwable!=null){
                WoosmapUtil.sendErrorResponse(callbackContext,PluginResult.Status.ERROR,throwable.getMessage());
            }
            else{
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void enqueGetPOIsRequest(CallbackContext callbackContext){
        getPOIsCallbackContexts.add(callbackContext);
        if (!isPOIFetchTaskRunning){
            //POIs
            CompletableFuture<JSONArray> getPOIsTask = CompletableFuture.supplyAsync(() -> {
                isPOIFetchTaskRunning = true;
                try {
                    POI[] pois;
                    JSONArray jsonArray = new JSONArray();
                    pois = WoosmapDb.getInstance(context).getPOIsDAO().getAllPOIs();
                    for (POI poi : pois) {
                        jsonArray.put(WoosmapUtil.getPOIObject(poi));
                    }
                    return jsonArray;

                } catch (Exception ex) {
                    throw new CompletionException(ex);
                }
            }).whenComplete((data, throwable) -> {
                PluginResult pluginResult;
                for (CallbackContext callbackContext1 : getPOIsCallbackContexts) {
                    if (throwable == null) {
                        pluginResult = new PluginResult(PluginResult.Status.OK, data);
                        pluginResult.setKeepCallback(false);
                        callbackContext1.sendPluginResult(pluginResult);
                    } else {
                        WoosmapUtil.sendErrorResponse(callbackContext1,PluginResult.Status.ERROR,throwable.getMessage(),false);
                    }
                }
                getPOIsCallbackContexts = new ArrayList<>();
                isPOIFetchTaskRunning = false;
            });
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void enqueGetLocationsRequest(CallbackContext callbackContext){
        getLocationsCallbackContexts.add(callbackContext);
        if (!isLocationsFetchTaskRunning){
            //Locations
            CompletableFuture<JSONArray> getLocationsTask = CompletableFuture.supplyAsync(() -> {
                isLocationsFetchTaskRunning = true;
                try {
                    MovingPosition[] movingPositions;
                    JSONArray jsonArray = new JSONArray();
                    movingPositions = WoosmapDb.getInstance(context).getMovingPositionsDao().getMovingPositions(-1);
                    for (MovingPosition location : movingPositions) {
                        jsonArray.put(WoosmapUtil.getMovingPositionObject(location));
                    }
                    return jsonArray;
                } catch (Exception ex) {
                    throw new CompletionException(ex);
                }
            }).whenComplete((data, throwable) -> {
                PluginResult pluginResult;
                for (CallbackContext callbackContext1 : getLocationsCallbackContexts) {
                    if (throwable == null) {
                        pluginResult = new PluginResult(PluginResult.Status.OK, data);
                        pluginResult.setKeepCallback(false);
                        callbackContext1.sendPluginResult(pluginResult);
                    } else {
                        WoosmapUtil.sendErrorResponse(callbackContext1,PluginResult.Status.ERROR,throwable.getMessage(),false);
                    }
                }
                getLocationsCallbackContexts = new ArrayList<>();
                isLocationsFetchTaskRunning = false;
            });
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void enqueGetVisitsRequest(CallbackContext callbackContext){
        getVisitsTaskCallbackContexts.add(callbackContext);
        if (!isVisitsFetchTaskRunning){
            //Visits
            CompletableFuture<JSONArray> getVisitsTask = CompletableFuture.supplyAsync(() -> {
                isVisitsFetchTaskRunning = true;
                try {

                    Visit[] visits;
                    JSONArray jsonArray = new JSONArray();
                    visits = WoosmapDb.getInstance(context).getVisitsDao().getAllStaticPositions();

                    for (Visit visit : visits) {
                        jsonArray.put(WoosmapUtil.getVisitObject(visit));
                    }

                    return jsonArray;
                } catch (Exception ex) {
                    throw new CompletionException(ex);
                }
            }).whenComplete((data, throwable) -> {
                PluginResult pluginResult;
                for (CallbackContext callbackContext1 : getVisitsTaskCallbackContexts) {
                    if (throwable == null) {
                        pluginResult = new PluginResult(PluginResult.Status.OK, data);
                        pluginResult.setKeepCallback(false);
                        callbackContext1.sendPluginResult(pluginResult);
                    } else {
                        WoosmapUtil.sendErrorResponse(callbackContext1,PluginResult.Status.ERROR,throwable.getMessage(),false);
                    }
                }
                getVisitsTaskCallbackContexts = new ArrayList<>();
                isVisitsFetchTaskRunning = false;
            });
        }
    }


    @RequiresApi(api = Build.VERSION_CODES.N)
    public void enqueGetRegionsRequest(CallbackContext callbackContext){
        getRegionsTaskCallbackContexts.add(callbackContext);
        if (!isRegionsFetchTaskRunning){
            //Regions
            CompletableFuture<JSONArray> getRegionsTask = CompletableFuture.supplyAsync(() -> {
                isRegionsFetchTaskRunning = true;
                try {

                    Region[] regions;
                    JSONObject jsonObject;
                    JSONArray jsonArray = new JSONArray();
                    regions = WoosmapDb.getInstance(context).getRegionsDAO().getAllRegions();

                    for (Region region : regions) {
                        jsonArray.put(WoosmapUtil.getRegionObject(region));
                    }
                    return jsonArray;
                } catch (Exception ex) {
                    throw new CompletionException(ex);
                }
            }).whenComplete((data, throwable) -> {
                PluginResult pluginResult;
                for (CallbackContext callbackContext1 : getRegionsTaskCallbackContexts) {
                    if (throwable == null) {
                        pluginResult = new PluginResult(PluginResult.Status.OK, data);
                        pluginResult.setKeepCallback(false);
                        callbackContext1.sendPluginResult(pluginResult);
                    } else {
                        WoosmapUtil.sendErrorResponse(callbackContext1,PluginResult.Status.ERROR,throwable.getMessage(),false);
                    }
                }
                getRegionsTaskCallbackContexts = new ArrayList<>();
                isRegionsFetchTaskRunning = false;
            });
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void enqueGetZOIsRequest(CallbackContext callbackContext){
        getZOIsTaskCallbackContexts.add(callbackContext);
        if (!isZOIsFetchTaskRunning){
            //ZOIs
            CompletableFuture<JSONArray> getZOIsTask = CompletableFuture.supplyAsync(() -> {
                isZOIsFetchTaskRunning = true;
                try {

                    ZOI[] zois;
                    JSONArray jsonArray = new JSONArray();
                    zois = WoosmapDb.getInstance(context).getZOIsDAO().getAllZois();
                    for (ZOI zoi : zois) {
                        jsonArray.put(WoosmapUtil.getZOIObject(zoi));
                    }

                    return jsonArray;
                } catch (Exception ex) {
                    throw new CompletionException(ex);
                }
            }).whenComplete((data, throwable) -> {
                PluginResult pluginResult;
                for (CallbackContext callbackContext1 : getZOIsTaskCallbackContexts) {
                    if (throwable == null) {
                        pluginResult = new PluginResult(PluginResult.Status.OK, data);
                        pluginResult.setKeepCallback(false);
                        callbackContext1.sendPluginResult(pluginResult);
                    } else {
                        WoosmapUtil.sendErrorResponse(callbackContext1,PluginResult.Status.ERROR,throwable.getMessage(),false);
                    }
                }
                getZOIsTaskCallbackContexts = new ArrayList<>();
                isZOIsFetchTaskRunning = false;
            });
        }
    }

}
