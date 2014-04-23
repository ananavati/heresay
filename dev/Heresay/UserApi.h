//
//  UserApi.h
//  Heresay
//
//  Created by Arpan Nanavati on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

@interface UserApi : NSObject

+ (UserApi *)instance;
- (void)saveUser:(User *)user;

@end
