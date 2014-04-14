//
//  ChatRoomApi.m
//  Heresay
//
//  Created by Arpan Nanavati on 4/12/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatRoomApi.h"

@interface ChatRoomApi ()

@property (strong, nonatomic) NSMutableArray *nearbyChatrooms;
@property (strong, nonatomic) PFQuery *query;

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
    self.query = [PFQuery queryWithClassName:[Chatroom parseClassName]];
    return self;
}

- (void)appendChatRooms:(NSArray *)chatRooms
{
    [self.nearbyChatrooms removeAllObjects];
    
    for (Chatroom *chatRoom in chatRooms) {
        // add to chatroom model to nearbychatrooms array
        [self.nearbyChatrooms addObject:[Chatroom initWithJSON:chatRoom]];
    }
}

- (void)fetchChatroomsNearLocation:(CLLocation *)location withSuccess:(void (^)(NSArray *chatrooms))success {
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
        }
    
        geoPoint = [PFGeoPoint geoPointWithLatitude:37.76245257053061 longitude:-122.5063083419809];

        [self.query whereKey:@"gelocation" nearGeoPoint:geoPoint];
        [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [self appendChatRooms:objects];
            success(self.nearbyChatrooms);
        }];
    }];
}

@end
