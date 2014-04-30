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
            author,
            chat_room_id,
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
        
		model.text = message[@"text"];

        id authorObject = message[@"author"];
        if (authorObject[@"profileImageUrl"]==nil) {
            model.author = @{@"name": authorObject[@"name"],
                            @"id": authorObject[@"id"]}; ;
        } else {
            model.author = @{@"name": authorObject[@"name"],
                             @"id": authorObject[@"id"], @"profileImageUrl": authorObject[@"profileImageUrl"]}; ;
        }
            
        

	}
    
    
    // TODO check user sending the messages
    // set self.sentFromCurrentUser = YES if needed
	model.sentFromCurrentUser = [model.author[@"id"] isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
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

-(Message *)initWithMessageText:(NSString *)messageText authorId:(NSString *)authorName authorProfileUrl:(NSString *)profileUrl uuid:(NSString *)uuid chatRoom:(NSString *)chatRoomId{

    // TODO set author ID
    self.sentFromCurrentUser = YES;
    self.author = @{@"name": authorName,
                    @"id": uuid, @"profileImageUrl": profileUrl};
    
    self.text = messageText;
    self.chat_room_id = chatRoomId;
    
    return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<Message [%@:%@]|%@ >", self.author[@"name"], self.text, self.author[@"profileImageUrl"]];
}

#pragma - JSMessageData

- (NSString *)sender{
    return self.author[@"name"];
}


@end
