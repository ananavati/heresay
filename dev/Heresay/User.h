//
//  User.h
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *profileImageURL;

@end
