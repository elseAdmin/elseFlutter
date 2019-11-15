#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    return YES;
}
- (void)initRegion
{
    static NSString *const kBeaconIdentifier = @"00000000-0000-0000-0000-000000000000";
    static NSString *const kCompanyIdentifier = @"00000000-0000-0000-0000-000000000000";//@"com.ustwo.myRegion";
    // Open Terminal on Mac and type uuidgen. Paste value here
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kBeaconIdentifier];
    
    // Setup the beacon region we want to look for. Comprises all beacons in that region
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           identifier:kCompanyIdentifier];
    
    // Start looking for beacon regions
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

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // Pick the last beacon from the set of beacons we discovered
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject]; // Note. assuming one beacon this is sufficient
    
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
@end
