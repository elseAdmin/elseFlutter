#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface AppDelegate : FlutterAppDelegate<CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (strong, nonatomic) FlutterMethodChannel *recieveMessagesFromDart;
@property (strong, nonatomic) FlutterViewController *controller;
@property (strong, nonatomic) FlutterMethodChannel *invokeDartMethod ;
@end
