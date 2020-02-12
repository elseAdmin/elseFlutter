package com.example.else_app_two;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.RemoteException;

import org.altbeacon.beacon.Beacon;
import org.altbeacon.beacon.BeaconConsumer;
import org.altbeacon.beacon.BeaconManager;
import org.altbeacon.beacon.RangeNotifier;
import org.altbeacon.beacon.Region;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements BeaconConsumer {
    private static final String TAG = "MainActivity";
    private static final int PERMISSION_REQUEST_FINE_LOCATION = 1;
    private static final int PERMISSION_REQUEST_BLUETOOTH = 2;
    private BeaconManager beaconManager = null;
    private static final String CHANNEL_TO_NATIVE = "com.else.apis.to.native";
    private static final String CHANNEL_FROM_NATIVE = "com.else.apis.from.native";
    public static BridgeHelper helper ;
    MethodChannel invokingDartMethods;

    public class BridgeHelper{
       public void invokeMethod(String methodName,Object arg){
           invokingDartMethods.invokeMethod(methodName,arg);
       }
       BridgeHelper getHelper(){
           return helper;
       }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        handleUserPermission();
        handleBeaconServices();
        handleBridgingServices();

    }

    private void handleBeaconServices(){
        BeaconReferenceApplication application= ((BeaconReferenceApplication) this.getApplication());
        application.enableMonitoring();
        helper = new BridgeHelper();
        beaconManager = BeaconManager.getInstanceForApplication(this);
    }

    private void handleBridgingServices(){
        new MethodChannel(getFlutterView(), CHANNEL_TO_NATIVE).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        // Note: this method is invoked on the main thread.
                        if (call.method.equals("nativeBridging")) {
                            result.success(nativeBridging());
                        }
                    }
                });



        invokingDartMethods = new MethodChannel(getFlutterView(), CHANNEL_FROM_NATIVE);
    }

    private String nativeBridging() {
        return "bridging is successful, returning value from native";
    }

    @Override
    public void onBeaconServiceConnect() {
        RangeNotifier rangeNotifier = new RangeNotifier() {
            @Override
            public void didRangeBeaconsInRegion(Collection<Beacon> beacons, Region region) {
                String universe =  determineUniverse(region);
                if (beacons.size() > 0) {
                    for(Beacon beacon : beacons){
                        List<String> beaconMeta = new ArrayList<>();
                        beaconMeta.add(beacon.getId1().toString());
                        beaconMeta.add(beacon.getId2().toString());
                        beaconMeta.add(beacon.getId3().toString());
                        beaconMeta.add(String.valueOf(beacon.getRssi()));
                        invokingDartMethods.invokeMethod("beaconFound",beaconMeta);
                        /*if(beacon.getId3().toString().compareTo("5")==0){
                            Log.i(TAG,"beacon details: id1="+beacon.getId1()+" id2="+beacon.getId2()+" id3="+beacon.getId3()+" rssi="+beacon.getRssi()+" distance = "+beacon.getDistance());
                        }*/
                    }
                }
            }

        };
        try {
           beaconManager.startRangingBeaconsInRegion(new Region("myRangingUniqueId", null, null, null));
           beaconManager.addRangeNotifier(rangeNotifier);
        } catch (RemoteException e) {
        }
    }

    private String determineUniverse(Region region) {
        return "UnityOne";
    }


    private void handleUserPermission(){
        //is bluetooth permission reqiured ?

        // handle other ccases of permissions
        if (this.checkSelfPermission(
                Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                    PERMISSION_REQUEST_FINE_LOCATION);
        }
        int permissionCheck = ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH);

        if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.BLUETOOTH}, PERMISSION_REQUEST_BLUETOOTH);
        } else {
            //TODO
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        //Task:should we unbind ?
        beaconManager.unbind(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        beaconManager.bind(this);
    }
}
