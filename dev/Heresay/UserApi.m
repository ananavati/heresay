//
//  UserApi.m
//  Heresay
//
//  Created by Arpan Nanavati on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "UserApi.h"
#import "User.h"

@interface UserApi ()

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) PFQuery *query;

@end

@implementation UserApi

+ (UserApi *)instance {
	static UserApi *instance = nil;
	static dispatch_once_t pred;
	
	if (instance) return instance;
	
	dispatch_once(&pred, ^{
		instance = [UserApi alloc];
		instance = [instance init];
	});
	
	return instance;
}

#pragma mark - users api methods
- (void)fetchUserForUuid:(NSString *)uuid withSuccess:(void (^)(User *user))success {
    [self.query whereKey:@"uuid" equalTo:uuid];
    
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.user = objects[0];
        success(self.user);
    }];
}


- (void)saveUser:(User *)user {
    PFObject *u = [PFObject objectWithClassName:@"users"];
    u[@"name"] = user.name;
    u[@"profileImageURL"] = user.profileImageURL;
    u[@"uuid"] = user.uuid;
    
    [u saveInBackground];
}

@end
