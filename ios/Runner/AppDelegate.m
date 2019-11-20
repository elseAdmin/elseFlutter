#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    [self initializeCoreLocationSpecificVariables];
    [self handleUserPermissionForCoreLocation];
    [self handleBeaconService];
    [self initializeBridgingSpecificVariables];
    [self handleBridgingService];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
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
