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
#import <JSMessagesViewController/JSMessage.h>

@interface Message : PFObject<PFSubclassing, JSMessageData>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *messageText;
@property (strong, nonatomic) NSString *authorName;
@property (strong, nonatomic) NSString *authorId;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic, assign) BOOL sentFromCurrentUser;




+ (Message *)initWithJSON:(Message *)json;
+ (NSDateFormatter *)longDateFormatter;
- (NSString *)description;
-(Message *)initWithMessageText:(NSString *)text authorId:(NSString *)author;
@end
