//
//  LocationManager.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *userLocation;

+ (LocationManager *)instance;

/**
 * Enables location services for this app;
 * Prompt the user to allow location services.
 */
- (void)enableLocationServices;

@end
