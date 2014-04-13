//
//  MessageApi.m
//  Heresay
//
//  Created by Arpan Nanavati on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "MessageApi.h"

@implementation MessageApi

+ (MessageApi *)instance {
	static MessageApi *instance = nil;
	static dispatch_once_t pred;
	
	if (instance) return instance;
	
	dispatch_once(&pred, ^{
		instance = [MessageApi alloc];
		instance = [instance init];
	});
	
	return instance;
}

@end
