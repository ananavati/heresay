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
@property (copy)void (^locationEnabledResult)(BOOL allowed);

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

- (BOOL)locationServicesEnabled {
	return ([CLLocationManager locationServicesEnabled] &&
			[CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

- (void)enableLocationServicesWithResult:(void (^)(BOOL allowed))result {
	self.locationEnabledResult = result;
	
	if ([self locationServicesEnabled]) {
		// already enabled
		self.userLocation = self.locationManager.location;
		return;
	}
	
	[self.locationManager startUpdatingLocation];
	
	// TODO: start/stop updating location as app goes to foreground/background
	// (applicationDidEnterBackground / WillEnterBackground)
//	[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	if (self.locationEnabledResult) {
		self.locationEnabledResult(YES);
		self.locationEnabledResult = nil;
	}
	self.userLocation = locations[0];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (self.locationEnabledResult) {
		self.locationEnabledResult(NO);
		self.locationEnabledResult = nil;
	}
}

@end
