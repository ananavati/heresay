//
//  User.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSMutableDictionary *)models {
	static NSMutableDictionary *modelsDict = nil;
	
	// Initialize only once.
	if (!modelsDict) {
		modelsDict = [NSMutableDictionary dictionary];
	}
	
	return modelsDict;
}

// TODO: This method may be obviated by Parse
+ (User *)initWithJSON:(NSDictionary *)json {
	User *model = [User models][json[@"objectId"]];
	if (!model) {
		model = [[User alloc] init];
		model.objectId = json[@"objectId"];
		model.name = json[@"name"];
		
		model.createdAt = json[@"created_at"];
		model.creationDate = [[User longDateFormatter] dateFromString:model.createdAt];
		model.creationDatestamp = [NSDateFormatter localizedStringFromDate:model.creationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
		
		model.profileImageURL = json[@"profileImageURL"];
		
		[User models][model.objectId] = model;
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
	return [NSString stringWithFormat:@"<User [%@]>", self.name];
}

@end
