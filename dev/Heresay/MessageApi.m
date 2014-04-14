//
//  MessageApi.m
//  Heresay
//
//  Created by Arpan Nanavati on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "MessageApi.h"

@interface MessageApi ()

@property (strong, nonatomic) NSMutableArray *messages;

@end

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

- (MessageApi *) init
{
    self = [super init];
    self.messages = [[NSMutableArray alloc] init];
    return self;
}

- (void)appendMessages:(NSArray *)messages
{
    [self.messages removeAllObjects];
    
    for (Message *message in messages) {
        // add to chatroom model to nearbychatrooms array
        [self.messages addObject:[Message initWithJSON:message]];
    }
}

#pragma mark - message api methods

- (void)fetchMessagesForChatroomWithId:(NSString *)chatroomId withSuccess:(void (^)(NSArray *messages))success {
    PFQuery *query = [PFQuery queryWithClassName:[Message parseClassName]];
    
    [query whereKey:@"chat_room_id" equalTo:chatroomId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self appendMessages:objects];
        success(self.messages);
    }];
}


@end
