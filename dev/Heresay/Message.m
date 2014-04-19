//
//  Message.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize messageText,
            authorName,
            authorId,
            date,
            sentFromCurrentUser;

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

// TODO:arpan dont need this method but leave it here for now
+ (Message *)initWithJSON:(Message *)message {
	Message *model = [Message models][message[@"objectId"]];

	if (!model) {
		model = [[Message alloc] init];
        
		model.messageText = message[@"text"];
		
        NSDictionary *author = message[@"author"];
        model.authorId = [author objectForKey:@"id"];
        model.authorName = [author objectForKey:@"name"];
	}
    
    
    // TODO check user sending the messages
    // set self.sentFromCurrentUser = YES if needed
	
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

-(Message *)initWithMessageText:(NSString *)text authorId:(NSString *)author{

    // TODO set author ID
    self.sentFromCurrentUser = YES;
    self.authorName = author;
    
    self.messageText = text;
    self.date = [[NSDate alloc]init];
    
    return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<Message [%@]>", self.text];
}

#pragma - JSMessageData

- (NSString *)text{
    return self.messageText;
}


- (NSString *)sender{
    return self.authorName;
}

- (NSDate *)date{
    return date;
}

@end
