 exports.defineAutoTests = function () {
        describe('cordova.plugins.WoosmapGeofencing',function(){

            var locationWatchId = '';
            var searchAPIWatchId = '';
            var distanceAPIWatchId = '';
            var visitWatchId = '';
            var regionWatchId = '';
            var airshipWatchId = '';
            var marketingCloudWatchId = '';
            var customNotificationCounter = 0;

            window.jasmine.DEFAULT_TIMEOUT_INTERVAL = 5000;

            it('1. Should be defined',function(){
                expect(cordova.plugins.WoosmapGeofencing).toBeDefined();
            });

            it('2. getPermissionsStatus should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.getPermissionsStatus).toEqual('function');
            });

            it('3. getPermissionsStatus Should check the permissions status', function(done){
                var win = function (data) {
                    expect(data).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.getPermissionsStatus(win, fail);
            });

            it('4. requestPermissions should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.requestPermissions).toEqual('function');
            });

            it('5. requestPermissions Should request background location permission', function(done){
                var win = function (data) {
                    expect(data).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.requestPermissions(true,win, fail);
            });

            it('6. requestPermissions Should request foreground location permission', function(done){
                var win = function (data) {
                    expect(data).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.requestPermissions(false,win, fail);
            });

            it('7. setWoosmapApiKey should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.setWoosmapApiKey).toEqual('function')
            });

            it('8. setWoosmapApiKey should throw exception when empty API key is passed', function(done){
                var win = function (p) {
                    console.error('Invalid API key was accepted');
                    expect(true).toEqual(false);
                    done();
                };
                var fail = function (e) {
                    console.log(e.message);
                    expect(e).toBeDefined();
                    done();
                };
                cordova.plugins.WoosmapGeofencing.setWoosmapApiKey('',win, fail);
            });

            it('9. initialize should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.initialize).toEqual('function')
            });

            it('10. initialize throw exception when invalid tracking profile is passed', function(done){
                var _config = {
                    trackingProfile: "abc profile"
                };
                var win = function (p) {
                    console.error('Invalid tracking profile was accepted');
                    expect(true).toEqual(false);
                    done();
                };
                var fail = function (e) {
                    console.log(e.message);
                    expect(e).toBeDefined();
                    done();
                };
                cordova.plugins.WoosmapGeofencing.initialize(_config,win, fail);
            });

            it('11. initialize Should initialize SDK when no config values are passed', function(done){
                var win = function (p) {
                    expect(p).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.initialize(null,win, fail);
            });

            it('12. setWoosmapApiKey should accept a non empty API key', function(done){
                var win = function (p) {
                    expect(p).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    console.error("key");
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.setWoosmapApiKey('3b705030-e85d-4bf0-a1be-5ac7372c91d5',win, fail);
            });

            it('13. watchLocation should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.watchLocation).toEqual('function')
            });

            it('14. watchLocation should return a watch Id', function(done){
                var win = function (location) {
                    expect(location).toBeDefined();
                    expect(location.latitude).toBeDefined();
                    expect(location.longitude).toBeDefined();
                    expect(location.locationid).toBeDefined();
                    expect(location.locationdescription).toBeDefined();
                    expect(location.date).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                locationWatchId = cordova.plugins.WoosmapGeofencing.watchLocation(win, fail);
                expect(locationWatchId).toBeDefined();
                done();
            });

            it('15. clearLocationWatch should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.clearLocationWatch).toEqual('function')
            });

            it('16. clearLocationWatch should clear location watch', function(done){
                cordova.plugins.WoosmapGeofencing.clearLocationWatch(locationWatchId);
                expect(true).toEqual(true);
                done();
            });

            it('17. watchSearchAPI should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.watchSearchAPI).toEqual('function')
            });

            it('18. watchSearchAPI should return a watch Id', function(done){
                var win = function (searchAPI) {};
                var fail = function (e) {};
                searchAPIWatchId = cordova.plugins.WoosmapGeofencing.watchSearchAPI(win, fail);
                expect(searchAPIWatchId).toBeDefined();
                done();
            });

            it('19. clearSearchApiWatch should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.clearSearchApiWatch).toEqual('function')
            });

            it('20. clearSearchApiWatch should clear search API watch', function(done){
                cordova.plugins.WoosmapGeofencing.clearSearchApiWatch(searchAPIWatchId);
                expect(true).toEqual(true);
                done();
            });

            it('21. watchDistanceApi should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.watchDistanceApi).toEqual('function')
            });

            it('22. watchDistanceApi should return a watch Id', function(done){
                var win = function (distanceAPI) {};
                var fail = function (e) {};
                distanceAPIWatchId = cordova.plugins.WoosmapGeofencing.watchDistanceApi(win, fail);
                expect(distanceAPIWatchId).toBeDefined();
                done();
            });

            it('23. clearDistanceApiWatch should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.clearDistanceApiWatch).toEqual('function')
            });

            it('24. clearDistanceApiWatch should clear distance API watch', function(done){
                cordova.plugins.WoosmapGeofencing.clearDistanceApiWatch(distanceAPIWatchId);
                expect(true).toEqual(true);
                done();
            });

            it('25. watchVisits should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.watchVisits).toEqual('function')
            });

            it('26. watchVisits should return a watch Id', function(done){
                var win = function (visits) {};
                var fail = function (e) {};
                visitWatchId = cordova.plugins.WoosmapGeofencing.watchVisits(win, fail);
                expect(visitWatchId).toBeDefined();
                done();
            });

            it('27. clearVisitsWatch should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.clearVisitsWatch).toEqual('function')
            });

            it('28. clearVisitsWatch should clear visits watch', function(done){
                cordova.plugins.WoosmapGeofencing.clearVisitsWatch(visitWatchId);
                expect(true).toEqual(true);
                done();
            });

            it('29. watchRegions should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.watchRegions).toEqual('function')
            });

            it('30. watchRegions should return a watch Id', function(done){
                var win = function (region) {};
                var fail = function (e) {};
                regionWatchId = cordova.plugins.WoosmapGeofencing.watchRegions(win, fail);
                expect(regionWatchId).toBeDefined();
                done();
            });

            it('31. clearRegionsWatch should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.clearRegionsWatch).toEqual('function')
            });

            it('32. clearRegionsWatch should clear regions watch', function(done){
                cordova.plugins.WoosmapGeofencing.clearRegionsWatch(regionWatchId);
                expect(true).toEqual(true);
                done();
            });

            it('33. watchAirship should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.watchAirship).toEqual('function')
            });

            it('34. watchAirship should return a watch Id', function(done){
                var win = function (airshipData) {};
                var fail = function (e) {};
                airshipWatchId = cordova.plugins.WoosmapGeofencing.watchAirship(win, fail);
                expect(airshipWatchId).toBeDefined();
                done();
            });

            it('35. clearAirshipWatch should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.clearAirshipWatch).toEqual('function')
            });

            it('36. clearAirshipWatch should clear airship events watch', function(done){
                cordova.plugins.WoosmapGeofencing.clearAirshipWatch(airshipWatchId);
                expect(true).toEqual(true);
                done();
            });

            it('37. addRegion should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.addRegion).toEqual('function')
            });

            it('38. addRegion should throw exception if no region info is passed', function(done){

                var win = function (data) {
                    console.error('Empty region added');
                    expect(true).toEqual(false);
                    done();
                };
                var fail = function (e) {
                    expect(e).toBeDefined();
                    console.log(e.message);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.addRegion(null,win,fail);

            });

            it('39. addRegion should add region in db if valid region info is passed', function(done){
                var request = {
                    "lat": 51.50998000,
                    "lng": -0.13370000,
                    "regionId": "7F91369E-467C-4CBD-8D41-6509815C4780",
                    "radius": 10,
                }

                var win = function (data) {
                    expect(data).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.addRegion(request,win,fail);
            });

            it('40. removeRegion should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.removeRegion).toEqual('function')
            });

            it('41. removeRegion should remove region from db if valid region info is passed', function(done){
                var request = {
                    "lat": 51.50998000,
                    "lng": -0.13370000,
                    "regionId": "7F91369E-467C-4CBD-8D41-6509815C4780",
                    "radius": 10,
                }

                var win = function (data) {
                    expect(data).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.removeRegion(request,win,fail);
            });

            it('42. removeRegion should remove all regions no region info is passed', function(done){

                var win = function (data) {
                    expect(data).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.removeRegion(null,win,fail);

            });

            it('43. startTracking should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.startTracking).toEqual('function')
            });

            it('44. startTracking should throw exception if profile is empty', function(done){
                var win = function (data) {
                    console.error('Tracking started without valid profile');
                    expect(true).toEqual(false);
                    done();
                };
                var fail = function (e) {
                    expect(e).toBeDefined();
                    console.log(e.message);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.startTracking('',win,fail);

            });

            it('45. startTracking should throw exception if profile is invalid', function(done){
                var win = function (data) {
                    console.error('Tracking started without valid profile');
                    expect(true).toEqual(false);
                    done();
                };
                var fail = function (e) {
                    expect(e).toBeDefined();
                    console.log(e.message);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.startTracking('abc',win,fail);

            });

            it('46. startTracking should start if profile is valid', function(done){
                var win = function (data) {
                    expect(data).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.startTracking('liveTracking',win,fail);

            });

            it('47. stopTracking should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.stopTracking).toEqual('function')
            });

            it('48. stopTracking should stop the tracking', function(done){
                var win = function (data) {
                    expect(data).toBeDefined();
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.stopTracking(win,fail);

            });

            it('49. customizeNotification should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.customizeNotification).toEqual('function')
            });

            it('50. customizeNotification should be customize notification UI on Android devices', function(done){
                customNotificationCounter++
                var config = {
                    WoosmapNotificationChannelID: "Channel_ID_" + customNotificationCounter,
                    WoosmapNotificationChannelName: "Channel_Name_" + customNotificationCounter,
                    WoosmapNotificationDescriptionChannel: "Channel_Description_" + customNotificationCounter,
                    updateServiceNotificationTitle: "Notification_Title_" + customNotificationCounter,
                    updateServiceNotificationText: "Notification_Text_" + customNotificationCounter,
                    WoosmapNotificationActive: true
                };
                cordova.plugins.WoosmapGeofencing.customizeNotification(config);
                expect(true).toEqual(true);
                done();
            });

            it('51. watchMarketingCloud should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.watchMarketingCloud).toEqual('function')
            });

            it('52. watchMarketingCloud should return a watch Id', function(done){
                var win = function (marketingCloudData) {};
                var fail = function (e) {};
                marketingCloudWatchId = cordova.plugins.WoosmapGeofencing.watchMarketingCloud(win, fail);
                expect(marketingCloudWatchId).toBeDefined();
                done();
            });

            it('53. clearMarketingCloudWatch should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.clearMarketingCloudWatch).toEqual('function')
            });

            it('54. clearMarketingCloudWatch should clear marketing cloud events watch', function(done){
                cordova.plugins.WoosmapGeofencing.clearMarketingCloudWatch(marketingCloudWatchId);
                expect(true).toEqual(true);
                done();
            });

            it('55. setPoiRadius should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapGeofencing.setPoiRadius).toEqual('function')
            });

            it('56. setPoiRadius should set radius to "radiusPOI"', function(done){
                var win = function (data) {
                    expect(true).toEqual(true);
                    done();
                };
                var fail = function (e) {
                    expect(e).toBeDefined();
                    console.log(e.message);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.setPoiRadius("radiusPOI",win,fail);

            });

            it('57. setPoiRadius should set radius to 100', function(done){
                var win = function (data) {
                    expect(true).toEqual(true);
                    done();
                };
                var fail = function (e) {
                    expect(e).toBeDefined();
                    console.log(e.message);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.setPoiRadius(100,win,fail);

            });

            it('58. setPoiRadius should not set radius to  100.20', function(done){
                var win = function (data) {
                    expect(true).toEqual(true);
                    done();
                };
                var fail = function (e) {
                    expect(e).toBeDefined();
                    console.log(e.message);
                    done();
                };
                cordova.plugins.WoosmapGeofencing.setPoiRadius(100.20,win,fail);

            });

        });

        describe('cordova.plugins.WoosmapDb',function(){
            it('1. Should be defined',function(){
                expect(cordova.plugins.WoosmapDb).toBeDefined();
            });


            it('2. getPois should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapDb.getPois).toEqual('function')
            });

            it('3. getPois should return an array', function(done){
                var win = function (result) {
                    expect(result).toBeDefined();
                    if (result.length > 0){
                        expect(result[0].date).toBeDefined();
                        expect(result[0].distance).toBeDefined();
                        expect(result[0].locationid).toBeDefined();
                        expect(result[0].latitude).toBeDefined();
                        expect(result[0].longitude).toBeDefined();
                        expect(result[0].city).toBeDefined();
                        expect(result[0].idstore).toBeDefined();
                        expect(result[0].name).toBeDefined();
                        //expect(result[0].duration).toBeDefined();
                        expect(result[0].zipcode).toBeDefined();
                        expect(result[0].jsondata).toBeDefined();
                    }
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapDb.getPois(win,fail);
            });

            it('4. getLocations should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapDb.getLocations).toEqual('function')
            });

            it('5. getLocations should return an array', function(done){
                var win = function (result) {
                    expect(result).toBeDefined();
                    if (result.length > 0){
                        expect(result[0].locationid).toBeDefined();
                        expect(result[0].latitude).toBeDefined();
                        expect(result[0].longitude).toBeDefined();
                        expect(result[0].locationdescription).toBeDefined();
                        expect(result[0].date).toBeDefined();
                    }
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapDb.getLocations(win,fail);
            });

            it('6. getVisits should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapDb.getVisits).toEqual('function')
            });

            it('7. getVisits should return an array', function(done){
                var win = function (result) {
                    expect(result).toBeDefined();
                    if (result.length > 0){
                        expect(result[0].id).toBeDefined();
                        expect(result[0].latitude).toBeDefined();
                        expect(result[0].longitude).toBeDefined();
                        expect(result[0].accuracy).toBeDefined();
                        expect(result[0].arrivaldate).toBeDefined();
                        expect(result[0].departuredate).toBeDefined();
                    }
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapDb.getVisits(win,fail);
            });

            it('8. getRegions should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapDb.getRegions).toEqual('function')
            });

            it('9. getRegions should return an array', function(done){
                var win = function (result) {
                    expect(result).toBeDefined();
                    if (result.length > 0){
                        expect(result[0].date).toBeDefined();
                        expect(result[0].latitude).toBeDefined();
                        expect(result[0].longitude).toBeDefined();
                        expect(result[0].didenter).toBeDefined();
                        expect(result[0].identifier).toBeDefined();
                        expect(result[0].radius).toBeDefined();
                        expect(result[0].frompositiondetection).toBeDefined();
                    }
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapDb.getRegions(win,fail);
            });

            it('10. getZois should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapDb.getZois).toEqual('function')
            });

            it('11. getZois should return an array', function(done){
                var win = function (result) {
                    expect(result).toBeDefined();
                    if (result.length > 0){
                        expect(result[0].accumulator).toBeDefined();
                        expect(result[0].age).toBeDefined();
                        expect(result[0].covariance_det).toBeDefined();
                        expect(result[0].duration).toBeDefined();
                        expect(result[0].endtime).toBeDefined();
                        expect(result[0].idvisits).toBeDefined();
                        expect(result[0].latmean).toBeDefined();
                        expect(result[0].lngmean).toBeDefined();
                        expect(result[0].period).toBeDefined();
                        expect(result[0].prior_probability).toBeDefined();
                        expect(result[0].starttime).toBeDefined();
                        expect(result[0].weekly_density).toBeDefined();
                        expect(result[0].wktpolygon).toBeDefined();
                        expect(result[0].x00covariance_matrix_inverse).toBeDefined();
                        expect(result[0].x01covariance_matrix_inverse).toBeDefined();
                        expect(result[0].x10covariance_matrix_inverse).toBeDefined();
                        expect(result[0].x11covariance_matrix_inverse).toBeDefined();
                    }
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapDb.getZois(win,fail);
            });

            it('12. deleteZoi should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapDb.deleteZoi).toEqual('function')
            });

            it('13. deleteZoi should delete all ZOIs', function(done){
                var win = function () {
                    expect(true).toEqual(true);
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapDb.deleteZoi(win,fail);
            });

            it('14. deleteLocation should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapDb.deleteLocation).toEqual('function')
            });

            it('15. deleteLocation should delete all locations', function(done){
                var win = function () {
                    expect(true).toEqual(true);
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapDb.deleteLocation(win,fail);
            });

            it('16. deleteVisit should be a function ', function(){
                expect(typeof cordova.plugins.WoosmapDb.deleteVisit).toEqual('function')
            });

            it('17. deleteVisit should delete all visits', function(done){
                var win = function () {
                    expect(true).toEqual(true);
                    done();
                };
                var fail = function (e) {
                    console.error(e.message);
                    expect(true).toEqual(false);
                    done();
                };
                cordova.plugins.WoosmapDb.deleteVisit(win,fail);
            });

        });
    }

    exports.defineManualTests = function (contentEl, createActionButton) {
        var activatePlugin = function () {
            var _config = {
                privateKeyWoosmapAPI: "3b705030-e85d-4bf0-a1be-5ac7372c91d5",
                privateKeyGMPStatic: "AIzaSyCNzj1iXlSnraLPjTBRpKa7mIDXWnvWF_4",
                trackingProfile: "liveTracking",
            }
            var win = function (p) {

            };
            var fail = function (e) {
                console.log(e.message);
            };
            cordova.plugins.WoosmapGeofencing.initialize(_config, win, fail);
        };
        activatePlugin();

        var logMessage = function (message, color) {
            var log = document.getElementById('info');
            var logLine = document.createElement('div');
            if (color) {
                logLine.style.color = color;
            }
            logLine.innerHTML = message;
            log.appendChild(logLine);
        };

        var clearLog = function () {
            var log = document.getElementById('info');
            log.innerHTML = '';
        };


        const showErrorLogs = function (result) {
            logMessage(JSON.stringify(result, null, '\t'),"red");
            console.log("error:"+ JSON.stringify(result));
        };
        const showSuccessLogs = function (result) {
            logMessage(JSON.stringify(result, null, '\t'),"green");
            //console.log(JSON.stringify(result));
        };

        const addActionText = function(contentEl,actionid,expectedresult){
            var add_tests =
                '<hr>' +
                '<div id="' + actionid + '"></div>' +
                'Expected result: '+ expectedresult;
            contentEl.innerHTML =  contentEl.innerHTML + add_tests;
        };

        contentEl.innerHTML = '<div id="info"></div>';

        addActionText(contentEl,"idaddregion", '{"regionid":"custom_7F91369E-467C-4CBD-8D41-6509815C4780","iscreated":true}');
        addActionText(contentEl,"idremoveregion", '{"status":"Removed"}');
        addActionText(contentEl,"idgetpois", '[{"locationid":"78B9D9EF-81AC-4EB3-B5B7-1B6043F50E93","zipcode":"33700","countrycode":"","idstore":"22342_213525","distance":265720,"duration":"3 hours 11 mins","date":1629115664943.0452,"latitude":45.694256,"address":"Aeroport de Bordeaux Merignac - Avenue Rene Cassin - null","name":"Bordeaux-AirportT.Billi(kiosk land)","radius":100,"types":"","longitude":-0.075161,"city":"Merignac","tags":""}]');
        addActionText(contentEl,"idLocations", '[{"locationdescription":"description","longitude":-1.561611190260122,"locationid":"78B9D9EF-81AC-4EB3-B5B7-1B6043F50E93","latitude":47.21572485738284,"date":1629115664492.895}]');
        addActionText(contentEl,"idgetvisits", "[]");
        addActionText(contentEl,"iddeletevisit", "Deleted");
        addActionText(contentEl,"idgetregions", '{"identifier": "poi_15711_154564_77 rue Rambuteau - 100.0 m","radius": 100,"latitude": 48.86213,"didenter": true,"longitude": 2.3494,"frompositiondetection": true,"date": 1629122339743.551}');
        addActionText(contentEl,"idgetzois", "[]");
        addActionText(contentEl,"iddeletezois", "Deleted");
        addActionText(contentEl,"iddeletelocation", "Deleted");
        addActionText(contentEl,"idcustomizenotification", "Sucess");

        createActionButton(
            'Get Locations',
            function () {
                clearLog();
                cordova.plugins.WoosmapDb.getLocations(showSuccessLogs, showErrorLogs);
            },
            'idLocations'
        );
        //Add Region
        createActionButton(
            'Add Region',
            function () {
                clearLog();
                const request = {
                    "lat": 51.50998000,
                    "lng": -0.13370000,
                    "regionId": "7F91369E-467C-4CBD-8D41-6509815C4780",
                    "radius": 10,
                };
                cordova.plugins.WoosmapGeofencing.addRegion(request, showSuccessLogs, showErrorLogs);
            },
            'idaddregion'
        );

        //Remove Region
        createActionButton(
            'Remove Region',
            function () {
                clearLog();
                const request = {
                    "lat": 51.50998000,
                    "lng": -0.13370000,
                    "regionId": "custom_7F91369E-467C-4CBD-8D41-6509815C4780",
                    "radius": 10,
                };
                cordova.plugins.WoosmapGeofencing.removeRegion(request, showSuccessLogs, showErrorLogs);
            },
            'idremoveregion'
        );

        createActionButton(
            'Get POIs',
            function () {
                clearLog();
                cordova.plugins.WoosmapDb.getPois(showSuccessLogs, showErrorLogs);
            },
            'idgetpois'
        );
        createActionButton(
            'Get Visits',
            function () {
                clearLog();
                cordova.plugins.WoosmapDb.getVisits(showSuccessLogs, showErrorLogs);
            },
            'idgetvisits'
        );
        createActionButton(
            'Delete Visit',
            function () {
                clearLog();
                cordova.plugins.WoosmapDb.deleteVisit(showSuccessLogs, showErrorLogs);
            },
            'iddeletevisit'
        );


        createActionButton(
            'Get Regions',
            function () {
                clearLog();
                cordova.plugins.WoosmapDb.getRegions(showSuccessLogs, showErrorLogs);
            },
            'idgetregions'
        );

        createActionButton(
            'Get ZOIs',
            function () {
                clearLog();
                cordova.plugins.WoosmapDb.getZois(showSuccessLogs, showErrorLogs);
            },
            'idgetzois'
        );

        createActionButton(
            'Delete ZOIs',
            function () {
                clearLog();
                cordova.plugins.WoosmapDb.deleteZoi(showSuccessLogs, showErrorLogs);
            },
            'iddeletezois'
        );

        createActionButton(
            'Delete Location',
            function () {
                clearLog();
                cordova.plugins.WoosmapDb.deleteLocation(showSuccessLogs, showErrorLogs);
            },
            'iddeletelocation'
        );

        createActionButton(
            'Customize Notification',
            function () {
                clearLog();
                var customNotificationCounter = 1;
                customNotificationCounter++
                var config = {
                    WoosmapNotificationChannelID: "Channel_ID_" + customNotificationCounter,
                    WoosmapNotificationChannelName: "Channel_Name_" + customNotificationCounter,
                    WoosmapNotificationDescriptionChannel: "Channel_Description_" + customNotificationCounter,
                    updateServiceNotificationTitle: "Notification_Title_" + customNotificationCounter,
                    updateServiceNotificationText: "Notification_Text_" + customNotificationCounter,
                    WoosmapNotificationActive: true
                };

                cordova.plugins.WoosmapDb.customizeNotification(showSuccessLogs, showErrorLogs);
            },
            'idcustomizenotification'
        );
    };

