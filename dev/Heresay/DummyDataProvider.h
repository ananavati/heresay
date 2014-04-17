//
//  DummyDataProvider.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/12/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Chatroom.h"
#import "Message.h"

@interface DummyDataProvider : NSObject

+ (DummyDataProvider *)instance;

- (User *)getAuthenticatedUser;

@end
