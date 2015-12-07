//
//  LocationLib.h
//  busAlarm
//
//  Created by phuongthuy on 11/14/15.
//  Copyright © 2015 PhuongThuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationModel.h"

@class LocationLib;

#pragma mark - Delegate
@protocol LocationLibDelegate <NSObject>

@optional

- (void)onCompareLocationSuccess:(LocationLib *)controller;
- (void)onAddLocationSuccess: (LocationLib *)controller;

@required

@end

#pragma mark - LocationLib

@interface LocationLib : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString *locationName;
}
+ (LocationLib *) shareLocation;
@property (nonatomic, weak) id <LocationLibDelegate> delegate;

- (void)initLocation;
- (void)addLocation;
- (void)deleteLocation: (LocationModel *)delLoc;
- (NSArray *)getLocations;

@end

