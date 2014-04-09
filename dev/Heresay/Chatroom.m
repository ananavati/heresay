//
//  Chatroom.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "Chatroom.h"

@implementation Chatroom

+ (NSMutableDictionary *)models {
	static NSMutableDictionary *modelsDict = nil;
	
	// Initialize only once.
	if (!modelsDict) {
		modelsDict = [NSMutableDictionary dictionary];
	}
	
	return modelsDict;
}

// TODO: This method may be obviated by Parse
+ (Chatroom *)initWithJSON:(NSDictionary *)json {
	Chatroom *model = [Chatroom models][json[@"objectId"]];
	if (!model) {
		model = [[Chatroom alloc] init];
		model.objectId = json[@"objectId"];
		model.name = json[@"name"];
		
		model.createdAt = json[@"created_at"];
		model.creationDate = [[Chatroom longDateFormatter] dateFromString:model.createdAt];
		model.creationDatestamp = [NSDateFormatter localizedStringFromDate:model.creationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
		
		model.radius = json[@"radius"];
		model.placeName = json[@"placeName"];
		model.location = [[CLLocation alloc]
						  initWithLatitude:[json[@"location"][@"latitude"] doubleValue]
						  longitude:[json[@"location"][@"longitude"] doubleValue]];
		
		// TODO: how will we store these on the client?
		// As User models, PFRelations, ids...?
		model.users = json[@"users"];
		model.admins = json[@"admins"];
		model.activeUsers = json[@"activeUsers"];
		model.nearbyUsers = json[@"nearbyUsers"];
		
		[Chatroom models][model.objectId] = model;
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
	return [NSString stringWithFormat:@"<Chatroom [%@]>", self.name];
}

@end
