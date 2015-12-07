//
//  LocationModel.m
//  busAlarm
//
//  Created by phuongthuy on 11/14/15.
//  Copyright © 2015 PhuongThuy. All rights reserved.
//

#import "LocationModel.h"
#import "Constants.h"

@implementation LocationModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.locationName forKey:k_LOCATION_NAME];
    [aCoder encodeObject:self.location forKey:k_LOCATION];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.locationName = [aDecoder decodeObjectForKey:k_LOCATION_NAME];
        self.location = [aDecoder decodeObjectForKey:k_LOCATION];
    }
    return self;
}

@end
