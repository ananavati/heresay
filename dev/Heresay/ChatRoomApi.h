//
//  ChatRoomApi.h
//  Heresay
//
//  Created by Arpan Nanavati on 4/12/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Chatroom.h"
#import "ChatroomMapViewController.h"

@interface ChatRoomApi : NSObject

+ (ChatRoomApi *)instance;

/**
 * Fetch chatrooms near the user's current location.
 * If user location not yet available, the success callback will be called after
 * user location becomes available and the nearby chatrooms are fetched.
 */
- (void)fetchChatroomsNearUserLocationWithSuccess:(void (^)(NSMutableArray *chatrooms))success;

/**
 * Fetch chatrooms near a specified location.
 */
- (void)fetchChatroomsNearLocation:(CLLocation *)location withSuccess:(void (^)(NSMutableArray *chatrooms))success;
- (void)fetchChatroomsInBoundingBoxWithSuccess:(GeoQueryBounds)geoBounds withSuccess:(void (^)(NSMutableArray *chatrooms))success;

- (PFObject *)saveChatRoom:(Chatroom *)chatRoom;

@end
