//
//  ChatRoomApi.m
//  Heresay
//
//  Created by Arpan Nanavati on 4/12/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatRoomApi.h"
#import "LocationManager.h"

@interface ChatRoomApi ()

@property (strong, nonatomic) NSMutableArray *nearbyChatrooms;
@property (strong, nonatomic) PFQuery *query;
@property (strong, nonatomic) NSMutableArray *pendingUserLocationSuccessBlocks;
@property (assign, nonatomic) BOOL isFetching;


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
    
    self.isFetching = NO;
    
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

- (void)fetchChatroomsNearUserLocationWithSuccess:(void (^)(NSMutableArray *chatrooms))success {
	LocationManager *locationManager = [LocationManager instance];
	CLLocation *userLocation = locationManager.userLocation;
	if (!userLocation) {
		// User location not yet available; process fetch request once it is
		if (!self.pendingUserLocationSuccessBlocks) {
			self.pendingUserLocationSuccessBlocks = [NSMutableArray new];
			
			// Watch LocationManager for resolution of user location
			[locationManager addObserver:self forKeyPath:@"userLocation" options:NSKeyValueObservingOptionNew context:NULL];
		}
		[self.pendingUserLocationSuccessBlocks addObject:success];

	} else {
		[self fetchChatroomsNearLocation:userLocation withSuccess:success];
	}
}

- (void)fetchChatroomsNearLocation:(CLLocation *)location withSuccess:(void (^)(NSMutableArray *chatrooms))success {
	[self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		[self appendChatRooms:objects];
		
		if (!success && self.pendingUserLocationSuccessBlocks) {
			for (void (^ successBlock)(NSArray *chatrooms) in self.pendingUserLocationSuccessBlocks) {
				successBlock(self.nearbyChatrooms);
			}
		} else {
			success(self.nearbyChatrooms);
		}
		
	}];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object == [LocationManager instance] && [keyPath isEqual: @"userLocation"]) {
		// LocationManager has resolved userLocation,
		// so fetch chatrooms with no success block;
		// on fetch completion, each of pendingUserLocationSuccessBlocks will be called with the response.
		LocationManager *locationManager = [LocationManager instance];
		if (self.pendingUserLocationSuccessBlocks) {
			[self fetchChatroomsNearLocation:locationManager.userLocation withSuccess:nil];
		}
		
		// No longer need to observe LocationManager for userLocation resolution.
		[locationManager removeObserver:self forKeyPath:@"userLocation"];
	}
}

//    use the following as an example to set up a chatroom and save it

//    Chatroom *chatRoom = [[Chatroom alloc] init];
//    chatRoom.chatRoomName = @"dummyroom";
//    chatRoom.radius = @100.0;
//    chatRoom.placeName = @"dummyplacename";
//    chatRoom.geolocation = [PFGeoPoint geoPointWithLatitude:40.0 longitude:-30.0];
//    chatRoom.latitude = @40.0;
//    chatRoom.longitude = @-30.0;
//
//    [[ChatRoomApi instance] saveChatRoom:chatRoom];

- (PFObject *) saveChatRoom:(Chatroom *)chatRoom {
    PFObject *c = [PFObject objectWithClassName:@"chat_rooms"];
    
    c[@"chatRoomName"] = chatRoom.chatRoomName;
    c[@"placeName"] = chatRoom.placeName;
    c[@"radius"] = chatRoom.radius;
    c[@"geolocation"] = chatRoom.geolocation;

    if ((chatRoom.latitude != nil) && (chatRoom.longitude != nil)) {
        c[@"latitude"] = chatRoom.latitude;
        c[@"longitude"] = chatRoom.longitude;
    }

    
    return c;
}

@end
