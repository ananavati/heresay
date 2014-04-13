//
//  ChatRoomApi.m
//  Heresay
//
//  Created by Arpan Nanavati on 4/12/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatRoomApi.h"
#import <Parse/Parse.h>

@interface ChatRoomApi ()

@property (strong, nonatomic) NSMutableArray *nearbyChatrooms;

@end

@implementation ChatRoomApi

+ (ChatRoomApi *)instance {
	static ChatRoomApi *instance = nil;
	static dispatch_once_t pred;
	
	if (instance) return instance;
	
	dispatch_once(&pred, ^{
		instance = [ChatRoomApi alloc];
		instance = [instance init];
	});
	
	return instance;
}

- (ChatRoomApi *) init
{
    self = [super init];
    self.nearbyChatrooms = [[NSMutableArray alloc] init];
    return self;
}

- (void)appendChatRooms:(NSArray *)chatRooms
{
    for (Chatroom *chatRoom in chatRooms) {
        // add to chatroom model to nearbychatrooms array
        [self.nearbyChatrooms addObject:[Chatroom initWithJSON:chatRoom]];
    }
}

- (void)fetchChatroomsNearLocation:(CLLocation *)location withSuccess:(void (^)(NSArray *chatrooms))success {
    PFQuery *query = [PFQuery queryWithClassName:@"chat_rooms"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self appendChatRooms:objects];
        success(self.nearbyChatrooms);
    }];
}

@end
