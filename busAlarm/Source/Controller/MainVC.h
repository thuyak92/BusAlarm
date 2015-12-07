//
//  MainVC.h
//  busAlarm
//
//  Created by phuongthuy on 11/14/15.
//  Copyright © 2015 PhuongThuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationLib.h"

@interface MainVC : UITableViewController<LocationLibDelegate>
{
    NSArray *locations;
    UILocalNotification *localNotification;
}

@end
