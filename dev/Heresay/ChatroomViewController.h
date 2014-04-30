//
//  ChatroomViewController.h
//  Heresay
//
//  Created by Thomas Ezan on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "Chatroom.h"

@interface ChatroomViewController : JSMessagesViewController <UITableViewDataSource, UITableViewDelegate, JSMessagesViewDelegate, JSMessagesViewDataSource>

-(id)initWithChatroom:(Chatroom *)chatroom userName:(NSString *)userName avatarImage:(UIImage*)image avatarUrl:(NSString *)avatarUrl;

@end
