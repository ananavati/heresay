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
 * Check if location services already enabled (both on the device, and for this app).
 */
- (BOOL)locationServicesEnabled;

/**
 * Check if we have a non-zero user location.
 */
- (BOOL)hasValidUserLocation;

/**
 * Enables location services for this app;
 * Prompt the user to allow location services.
 */
- (void)enableLocationServicesWithResult:(void (^)(BOOL allowed))result;

@end
