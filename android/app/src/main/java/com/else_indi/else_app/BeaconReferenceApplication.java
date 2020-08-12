package com.else_indi.else_app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

import org.altbeacon.beacon.BeaconManager;
import org.altbeacon.beacon.BeaconParser;
import org.altbeacon.beacon.Identifier;
import org.altbeacon.beacon.Region;
import org.altbeacon.beacon.startup.BootstrapNotifier;
import org.altbeacon.beacon.startup.RegionBootstrap;

import io.flutter.app.FlutterApplication;

public class BeaconReferenceApplication extends FlutterApplication implements BootstrapNotifier {
    private static final String TAG = "BeaconReferenceApplication";
    private RegionBootstrap regionBootstrap;
    MainActivity.BridgeHelper helper;
    public void onCreate() {
        super.onCreate();
        buildBeaconConfiguration();
        initRegion();
    }
    private void initRegion(){
        Region region = new Region("backgroundRegion",
                Identifier.parse("00000000-0000-0000-0000-000000000000"), null, null);
        regionBootstrap = new RegionBootstrap(this, region);
    }
    private void buildBeaconConfiguration(){
        BeaconManager beaconManager = org.altbeacon.beacon.BeaconManager.getInstanceForApplication(this);
        beaconManager.getBeaconParsers().clear();
        //donot change the below value
        beaconManager.getBeaconParsers().add(new BeaconParser().
                setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24")); //iBeacon specific value
        beaconManager.setDebug(false);
        Notification notification = getNotificationForForegroundScan();
        beaconManager.enableForegroundServiceScanning(notification, 456);
        beaconManager.setEnableScheduledScanJobs(false);
        beaconManager.setBackgroundBetweenScanPeriod(0);
        beaconManager.setBackgroundScanPeriod(1100);
    }

    private Notification getNotificationForForegroundScan() {
        Notification.Builder builder = new Notification.Builder(this);
        builder.setSmallIcon(R.drawable.ic_launcher);
        builder.setContentTitle("Scanning for Beacons");
        Intent intent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(
                this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT
        );
        builder.setContentIntent(pendingIntent);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("My Notification Channel ID",
                    "My Notification Name", NotificationManager.IMPORTANCE_DEFAULT);
            channel.setDescription("My Notification Channel Description");
            NotificationManager notificationManager = (NotificationManager) getSystemService(
                    Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(channel);
            builder.setChannelId(channel.getId());
        }
        return builder.build();
    }

    //should we use this method ? any benefits ?
    public void disableMonitoring() {
        if (regionBootstrap != null) {
            regionBootstrap.disable();
            regionBootstrap = null;
        }
    }

    //is this method required?
    public void enableMonitoring() {
        Region region = new Region("backgroundRegion",
                Identifier.parse("00000000-0000-0000-0000-000000000000"), null, null);
        regionBootstrap = new RegionBootstrap(this, region);
    }


    @Override
    public void didEnterRegion(Region region) {
        Log.i(TAG, "Enter Region: "+region.toString());
    }

    @Override
    public void didExitRegion(Region region) {
        Log.i(TAG, "Exit Region: "+region.toString());
    }

    @Override
    public void didDetermineStateForRegion(int state, Region region) {
        Log.i(TAG, "Current region state is: " + (state == 1 ? "INSIDE" : "OUTSIDE (" + state + ")"));
    }

}
