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

@interface ChatRoomApi : NSObject

+ (ChatRoomApi *)instance;

- (void)fetchChatroomsNearLocation:(CLLocation *)location withSuccess:(void (^)(NSArray *chatrooms))success;
@end
