#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#define DEVICE_INFO_SERVICE_UUID @"00000000-0000-0000-0000-000000000000"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.centralManager = [[CBCentralManager alloc] init];
    self.peripheralManager = [[CBPeripheralManager alloc] init];
    
    NSLog(@"peripheral manager and central manager initialized");
    
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn)
    {
        NSLog(@"peripheral Powered On");
    }
    else if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOff)
    {
        NSLog(@"peripheral Powered Off");
    }
    NSLog(@"fetching authorization status code");
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    NSLog(@"%@",status);
    //permission
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
         NSLog(@"location permission not granted");
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        NSLog(@"location permission already granted");
    }
    if([CLLocationManager isMonitoringAvailableForClass:self.beaconRegion]){
        NSLog(@"device found capable of monitoring beacons");
    }
    [self initRegion];
    [self.locationManager startUpdatingLocation];
    NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID], nil];
   
   FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* invokeDartMethod = [FlutterMethodChannel
                                              methodChannelWithName:@"com.else.apis.from.native"
                                              binaryMessenger:controller];
    
    FlutterMethodChannel* recieveMessagesFromDart = [FlutterMethodChannel
                                                     methodChannelWithName:@"com.else.apis.to.native"
                                                     binaryMessenger:controller];
    
    [invokeDartMethod invokeMethod:@"universeIdentified"
                         arguments:@"UnityOne"];
    
    [recieveMessagesFromDart setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // Note: this method is invoked on the UI thread.
        // TODO
        if ([call.method isEqualToString:@"nativeBridging"]) {
            NSLog(@"Native Method invoked by flutter");
        }
    }];
   return [super application:application didFinishLaunchingWithOptions:launchOptions];;
    // should/can initRegion be called before didFinishLaunchingWithOptions ????
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"inside didUpdateLocations");
    NSLog(@"%@", [locations lastObject]);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    NSLog(@"Check BT status");
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID], nil];
            [self.centralManager scanForPeripheralsWithServices:services options:nil];
    }
    
}

- (void)peripheralManager:(CBPeripheralManager *)perimanager peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"%@",peripheral.state);
}
- (void)initRegion
{
    static NSString *const kBeaconIdentifier = @"00000000-0000-0000-0000-000000000000";
    static NSString *const kCompanyIdentifier = @"00000000-0000-0000-0000-000000000000";//@"com.ustwo.myRegion";

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kBeaconIdentifier];
    
    // Setup the beacon region we want to look for. Comprises all beacons in that region
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           identifier:kCompanyIdentifier];
    
    // Start looking for beacon regions
    NSLog(@"Monitoring is starting now");
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
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
        CLBeacon *beacon = [[CLBeacon alloc] init];
        beacon = [beacons objectAtIndex:i];
    
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
@end
