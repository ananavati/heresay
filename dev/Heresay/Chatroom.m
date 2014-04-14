//
//  Chatroom.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "Chatroom.h"

@implementation Chatroom

@synthesize radius,
            chatRoomName,
            placeName,
            geolocation;

// this is the collection/table_name
+ (NSString *)parseClassName {
    return @"chat_rooms";
}

+ (NSMutableDictionary *)models {
	static NSMutableDictionary *modelsDict = nil;
	
	// Initialize only once.
	if (!modelsDict) {
		modelsDict = [NSMutableDictionary dictionary];
	}
	
	return modelsDict;
}

+ (Chatroom *)initWithJSON:(Chatroom *)chatRoom {
	Chatroom *model = [Chatroom models][chatRoom[@"objectId"]];
	if (!model) {
        model = [Chatroom object];
        
        model.chatRoomName = chatRoom[@"chatRoomName"];
		model.radius = chatRoom[@"radius"];
		model.placeName = chatRoom[@"placeName"];
        model.geolocation = [PFGeoPoint geoPointWithLatitude:[chatRoom[@"latitude"] doubleValue] longitude:[chatRoom[@"longitude"] doubleValue]];

		// TODO: how will we store these on the client?
		// As User models, PFRelations, ids...?
//		model.users = json[@"users"];
//		model.admins = json[@"admins"];
//		model.activeUsers = json[@"activeUsers"];
//		model.nearbyUsers = json[@"nearbyUsers"];
	}
	
	return model;
}

+ (NSDateFormatter *)longDateFormatter {
	static NSDateFormatter *longDateFormatter;
	
	if (!longDateFormatter) {
		longDateFormatter = [[NSDateFormatter alloc] init];
		[longDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
		[longDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
	}
	
	return longDateFormatter;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<Chatroom [%@]>", self.chatRoomName];
}

@end