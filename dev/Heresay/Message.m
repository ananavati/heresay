//
//  Message.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize text,
            authorId;

// this is the collection/table_name
+ (NSString *)parseClassName {
    return @"messages";
}

+ (NSMutableDictionary *)models {
	static NSMutableDictionary *modelsDict = nil;
	
	// Initialize only once.
	if (!modelsDict) {
		modelsDict = [NSMutableDictionary dictionary];
	}
	
	return modelsDict;
}

// TODO: This method may be obviated by Parse
+ (Message *)initWithJSON:(NSDictionary *)json {
	Message *model = [Message models][json[@"objectId"]];

	if (!model) {
		model = [[Message alloc] init];
		model.objectId = json[@"objectId"];
		model.text = json[@"text"];
		model.authorId = json[@"authorId"];
		
        [Message models][model.objectId] = model;
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
	return [NSString stringWithFormat:@"<Message [%@]>", self.text];
}

@end
