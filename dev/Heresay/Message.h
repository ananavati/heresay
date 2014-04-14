//
//  Message.h
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>
#import <Parse/Parse.h>

@interface Message : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *authorId;


+ (Message *)initWithJSON:(Message *)json;
+ (NSDateFormatter *)longDateFormatter;
- (NSString *)description;

@end
