//
//  UserApi.m
//  Heresay
//
//  Created by Arpan Nanavati on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "UserApi.h"

@implementation UserApi

+ (UserApi *)instance {
	static UserApi *instance = nil;
	static dispatch_once_t pred;
	
	if (instance) return instance;
	
	dispatch_once(&pred, ^{
		instance = [UserApi alloc];
		instance = [instance init];
	});
	
	return instance;
}

@end
