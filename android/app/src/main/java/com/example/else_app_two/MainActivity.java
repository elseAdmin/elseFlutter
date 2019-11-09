package com.example.else_app_two;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String TAG = "BeaconReferenceApp";
  private static final String CHANNEL = "samples.flutter.dev/battery";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                // Note: this method is invoked on the main thread.
                  if (call.method.equals("nativeBrigding")) {
                      result.success(nativeBrigding());
                  }
              }
            });
  }

  private String nativeBrigding(){
    return "brigding is succesful";
  }
}
