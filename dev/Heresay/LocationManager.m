//
//  LocationManager.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation LocationManager

/**
 * Objective-C Singleton pattern, from:
 * http://stackoverflow.com/questions/2199106/thread-safe-instantiation-of-a-singleton#answer-2202304
 */
+ (LocationManager *)instance {
	static LocationManager *instance = nil;
	static dispatch_once_t pred;
	
	if (instance) return instance;
	
	dispatch_once(&pred, ^{
		instance = [LocationManager alloc];
		instance = [instance init];
	});
	
	return instance;
}

- (LocationManager *)init {
	self = [super init];
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	
	return self;
}

- (void)enableLocationServices {
	if ([CLLocationManager locationServicesEnabled] &&
		[CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
		// already enabled
		return;
	}
	
	[self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	//
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	//
}


@end
