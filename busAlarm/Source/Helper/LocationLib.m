//
//  LocationLib.m
//  busAlarm
//
//  Created by phuongthuy on 11/14/15.
//  Copyright © 2015 PhuongThuy. All rights reserved.
//

#import "LocationLib.h"
#import "Constants.h"
#import "LocationModel.h"

@interface LocationLib ()

@end

@implementation LocationLib

static LocationLib *shareLocation = nil;

+ (LocationLib *) shareLocation
{
    @synchronized (self)
    {
        if (shareLocation == nil){
            shareLocation = [[LocationLib alloc] init];
        }
    }
    return shareLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)initLocation
{
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //xac dinh vi tri voi do chinh xac 100m
    locationManager.distanceFilter = 400; //thong bao thay doi khi thiet bi da di chuyen 400m
    locationManager.delegate = self;
    currentLocation = [[CLLocation alloc] init];
}

#pragma mark - common function

- (void)addLocation
{
    if (locationName && currentLocation) {
        LocationModel *loc = [[LocationModel alloc] init];
        loc.location = currentLocation;
        loc.locationName = locationName;
        NSLog(@"location name = %@, location = %@", loc.locationName, loc.location);
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[self getLocations]];
        for (LocationModel *obj in arr) {
            if ([obj.locationName isEqualToString:locationName]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Location was added!" preferredStyle: UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
        }
        [arr addObject:loc];
        NSData *locData = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [[NSUserDefaults standardUserDefaults] setObject:locData forKey:k_DEFAULT_LOCATION];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([self.delegate respondsToSelector:@selector(onAddLocationSuccess:)]) {
            [self.delegate onAddLocationSuccess:self];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Can not add current location." preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)deleteLocation:(LocationModel *)delLoc
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[self getLocations]];
    NSMutableArray *delArr = [[NSMutableArray alloc] init];
    for (LocationModel *obj in arr) {
        if ([obj.locationName isEqualToString:delLoc.locationName]) {
            [delArr addObject:obj];
            break;
        }
    }
    [arr removeObjectsInArray:delArr];
    NSData *locData = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults] setObject:locData forKey:k_DEFAULT_LOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getLocations
{
    NSData *locData = [[NSUserDefaults standardUserDefaults] objectForKey:k_DEFAULT_LOCATION];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:locData];
    return arr;
}

- (BOOL)compareLocation:(CLLocation *)location inLocations: (NSArray *)locs
{
    for (LocationModel *defaultLoc in locs) {
        double distance = [location distanceFromLocation:defaultLoc.location];//get distance by metter
        if (distance <= 300) {
            return TRUE;
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:k_PREVENT_ALARM];
    return FALSE;
}

#pragma mark - Location Manager delegate

- (void)checkLocationStatus
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled]) {
        switch (status) {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                locationManager.pausesLocationUpdatesAutomatically = NO;
                
                [locationManager startUpdatingLocation];
                if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
                    [locationManager setAllowsBackgroundLocationUpdates:YES];
                }
//                [locationManager startMonitoringSignificantLocationChanges];
                
                status = [CLLocationManager authorizationStatus];
                break;
            case kCLAuthorizationStatusNotDetermined:
                if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])//iOS 8+
                {
                    [locationManager requestAlwaysAuthorization];
                    locationManager.allowsBackgroundLocationUpdates = YES;
                }
                break;
            default:
                break;
        }
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"The location services seems to be disabled from the settings." preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    NSArray *locs = [self getLocations];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            locationName = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.name];
        }
    }];
    
    if ([self compareLocation:currentLocation inLocations:locs])
    {
        //alarm
        if ([self.delegate respondsToSelector:@selector(onCompareLocationSuccess:)]) {
            [self.delegate onCompareLocationSuccess:self];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Change in authorization status");
    [self checkLocationStatus];
}

@end
