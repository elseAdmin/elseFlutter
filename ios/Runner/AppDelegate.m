#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    [self initializeCoreLocationSpecificVariables];
//    [self detectBluetooth];
//    [self handleUserPermissionForCoreLocation];
//    [self handleBeaconService];
//    [self initializeBridgingSpecificVariables];
//    [self handleBridgingService];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//- (void)centralManagerDidUpdateState:(CBCentralManager*)aManager
//{
//    if( aManager.state == CBManagerStatePoweredOn )
//    {
//        //Do what you intend to do
//        NSLog(@"Bluetooth is powered on");
//    }
//    else if( aManager.state == CBManagerStatePoweredOff )
//    {
//        //Bluetooth is disabled. ios pops-up an alert automatically
//        NSLog(@"Bluetooth is off switch to settings for info");
//    }
//}

- (void)detectBluetooth
{
    if(!self.bluetoothManager)
    {
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Bluetooth checking");
    NSString *stateString = nil;
    if (self.bluetoothManager.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"Bluetooth is Powered on");
        stateString = @"Bluetooth is Powered on";
    } else {
        NSLog(@"Bluetooth is Powered Off");
        stateString = @"Bluetooth is Powered off. Power On bluetooth";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth state"
                                                         message:stateString
                                                        delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
//    switch(self.bluetoothManager.state)
//    {
//        case CBCentralManagerStateResetting: stateString = @"The connection with the system service was momentarily lost, update imminent."; break;
//        case CBCentralManagerStateUnsupported: stateString = @"The platform doesn't support Bluetooth Low Energy."; break;
//        case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth Low Energy."; break;
//        case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off."; break;
//        case CBCentralManagerStatePoweredOn: stateString = @"Bluetooth is currently powered on and available to use."; break;
//        default: stateString = @"State unknown, update imminent."; break;
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth state"
//                                                     message:stateString
//                                                    delegate:nil
//                                          cancelButtonTitle:@"ok" otherButtonTitles: nil];
//    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    NSLog(@"User clicked ok switch to settings");
    if (buttonIndex == 0) {
        // do something here...
        NSLog(@"Button Pressed");
        
        NSURL *url = [NSURL URLWithString:@"App-prefs:root=Bluetooth"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)handleBridgingService{
    [self.recieveMessagesFromDart setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // Note: this method is invoked on the UI thread.
        // TODO
        if ([call.method isEqualToString:@"nativeBridging"]) {
            //call ios method here and return a future
            NSLog(@"Native Method invoked by flutter");
        }
    }];
}

- (void)initializeBridgingSpecificVariables
{
    self.controller = (FlutterViewController*)self.window.rootViewController;
    self.recieveMessagesFromDart = [FlutterMethodChannel
                                    methodChannelWithName:@"com.else.apis.to.native"
                                    binaryMessenger:self.controller];
    self.invokeDartMethod = [FlutterMethodChannel
                             methodChannelWithName:@"com.else.apis.from.native"
                             binaryMessenger:self.controller];
}

- (void)handleBeaconService
{
    //flutter on start up should call native method to inject all uuids to scan in initRegion()
    [self initRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)initializeCoreLocationSpecificVariables
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)handleUserPermissionForCoreLocation
{
    //handle other cases of denied permission and add flow for requesting permission again on denial.
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"location permission not granted");
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        NSLog(@"location permission already granted");
    }
}

- (void)initRegion
{
    static NSString *const kBeaconIdentifier = @"00000000-0000-0000-0000-000000000000";
    static NSString *const kCompanyIdentifier = @"00000000-0000-0000-0000-000000000000";//@"com.ustwo.myRegion";

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kBeaconIdentifier];
    // Setup the beacon region we want to look for. Comprises all beacons in that region
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           identifier:kCompanyIdentifier];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Enter region called");
    // Entered a beacon region. So now start discovering all beacons in the region.
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"Exit region called");
}

- (void)locationManager:(CLLocationManager *)locationManager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"inside didRangeBeacons method");
    for(int i = 0; i < [beacons count]; i++){
    CLBeacon *beacon = [beacons objectAtIndex:i];
    [self returnUniverseByUUID:beacon.proximityUUID.UUIDString];
    // Update UI
    NSLog(@"%@", beacon.proximityUUID.UUIDString);
    NSLog(@"%@", [NSString stringWithFormat:@"%@", beacon.major]);
    NSLog(@"%@", [NSString stringWithFormat:@"%@", beacon.minor]);
    NSLog(@"%@", [NSString stringWithFormat:@"%f", beacon.accuracy]);
    NSLog(@"%@", [NSString stringWithFormat:@"%li", (long)beacon.rssi]);
    
    if (beacon.proximity == CLProximityUnknown)
    {
       NSLog(@"Unknown Proximity");
    }
    else if (beacon.proximity == CLProximityImmediate) // e.g. half meter or so away
    {
        NSLog(@"Immediate");
    }
    else if (beacon.proximity == CLProximityNear) // e.g. a meter or so
    {
        NSLog(@"Near");
    }
    else if (beacon.proximity == CLProximityFar) // e.g. several meters away
    {
        NSLog(@"Far");
    }
}
}

- (void)returnUniverseByUUID:(NSString *)uuid
{
    //do we need to close this channel manually ? or its auto managed?
    [self.invokeDartMethod invokeMethod:@"universeIdentified"
                         arguments:@"UnityOne"];
}
@end
