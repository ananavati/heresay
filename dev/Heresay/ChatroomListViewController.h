//
//  ChatroomListViewController.h
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatroomSelectorDelegate.h"

@interface ChatroomListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id<ChatroomSelectorDelegate> delegate;

@end
