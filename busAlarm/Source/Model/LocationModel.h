//
//  LocationModel.h
//  busAlarm
//
//  Created by phuongthuy on 11/14/15.
//  Copyright © 2015 PhuongThuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationModel : NSObject

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) CLLocation *location;

@end
