//
//  User.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize name,
            profileImageURL,
            uuid,
            avatarImage;

// this is the collection/table_name
+ (NSString *)parseClassName {
    return @"users";
}

+ (NSMutableDictionary *)models {
	static NSMutableDictionary *modelsDict = nil;
	
	// Initialize only once.
	if (!modelsDict) {
		modelsDict = [NSMutableDictionary dictionary];
	}
	
	return modelsDict;
}
// TODO:arpan dont need this method but leave it here for now
+ (User *)initWithJSON:(User *)user {
	User *model = [User models][user[@"objectId"]];
    
	if (!model) {
		model = [[User alloc] init];

		model.name = user[@"name"];
		model.profileImageURL = user[@"profileImageURL"];
        model.uuid = user[@"uuid"];
        
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
	return [NSString stringWithFormat:@"<User [%@] [%@]>", self.name, self.uuid];
}

@end
