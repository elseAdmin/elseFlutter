#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface AppDelegate : FlutterAppDelegate<CLLocationManagerDelegate,CBPeripheralManagerDelegate,CBCentralManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBCentralManager *centralManager;

@end
