//
//  MessageApi.h
//  Heresay
//
//  Created by Arpan Nanavati on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Message.h"

@interface MessageApi : NSObject

+ (MessageApi *)instance;

- (void)fetchMessagesForChatroomWithId:(NSString *)chatroomId withSuccess:(void (^)(NSArray *messages))success;

@end
