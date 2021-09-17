package cordova.plugin.woosmapgeofencing;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;

import com.webgeoservices.woosmapgeofencing.FigmmForVisitsCreator;
import com.webgeoservices.woosmapgeofencing.PositionsManager;
import com.webgeoservices.woosmapgeofencing.database.MovingPosition;
import com.webgeoservices.woosmapgeofencing.database.Visit;
import com.webgeoservices.woosmapgeofencing.database.WoosmapDb;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;
import java.util.function.Supplier;

/***
 * Utility class for simulating test data
 */
public class TestUtil {
    private static final String TAG = "TestUtil";

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static void createTestZOIs(final Context context){
        CompletableFuture.supplyAsync((Supplier<Void>) () -> {
            try{

                InputStream in = context.getResources().openRawResource(context.getResources().getIdentifier(
                        "visit_qualif","raw",context.getPackageName()));

                DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss+SS");
                BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                String line = null;
                FigmmForVisitsCreator figmmForVisitsCreator = new FigmmForVisitsCreator(WoosmapDb.getInstance(context));

                int i = 0;
                while ((line = reader.readLine()) != null) {
                    String[] separated = line.split(",");
                    String id = separated[0];
                    double accuracy = Double.valueOf(separated[1]);
                    String[] valLatLng = separated[2].replace("POINT(","").replace(")","").split(" ");

                    double x = Double.valueOf(valLatLng[0]);
                    double y = Double.valueOf(valLatLng[1]);

                    long startime = formatter.parse(separated[3]).getTime();
                    long endtime = formatter.parse(separated[4]).getTime();

                    Visit visit = new Visit();
                    visit.lat = y;
                    visit.lng = x;
                    visit.startTime = startime;
                    visit.endTime = endtime;
                    visit.accuracy = (float) accuracy;
                    visit.uuid = id;
                    visit.duration = visit.endTime - visit.startTime;

                    WoosmapDb.getInstance(context).getVisitsDao().createStaticPosition(visit);

                    figmmForVisitsCreator.figmmForVisitTest(visit);
                    i++;
                }
                figmmForVisitsCreator.update_db();
            }
            catch (Exception ex){
                Log.e(TAG,ex.toString());
                throw new CompletionException(ex);
            }
            return null;
        }).whenComplete((unused, throwable) -> {
            if (throwable != null){
                Log.d(TAG,"ZOI Created");
            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static void testAirshipCallbacks(final CallbackContext callbackContext, final Context context){
        CompletableFuture.supplyAsync(() -> {
            MovingPosition[] movingPosition = WoosmapDb.getInstance(context).getMovingPositionsDao().getMovingPositions(-1);
            return movingPosition;
        }).whenComplete((result, throwable) -> {
            if (throwable==null){
                if (result.length>0){
                    PositionsManager positionsManager = new PositionsManager(context,WoosmapDb.getInstance(context));
                    positionsManager.requestSearchAPI(result[0]);
                }
            }
        });
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
    }
}
