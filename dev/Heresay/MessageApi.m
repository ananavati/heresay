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
@property (strong, nonatomic) PFQuery *query;
@property (assign, nonatomic) BOOL isFetching;

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
    self.query = [PFQuery queryWithClassName:[Message parseClassName]];
    self.isFetching = NO;
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
    if (!self.isFetching) {
        self.isFetching = YES;
        [self.query whereKey:@"chat_room_id" equalTo:chatroomId];
        
        [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [self appendMessages:objects];
            success(self.messages);
            self.isFetching = NO;
        }];
    } else {
        NSLog(@"is currently already fetching the messages... be patient!");
    }
}

- (void)saveMessage:(Message *)message {
    PFObject *m = [PFObject objectWithClassName:@"messages"];
    m[@"text"] = message.text;
    m[@"chat_room_id"] = message.chat_room_id;
    m[@"author"] = message.author;
    
    [m saveInBackground];
}

@end
