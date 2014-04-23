//
//  ChatroomCardsViewController.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatroomSelectorDelegate.h"
#import "ChatroomCardViewCell.h"

@interface ChatroomCardsViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, ChatroomCardViewDelegate>

@property (strong, nonatomic) NSMutableArray *chatroomModels;
@property (strong, nonatomic) id<ChatroomSelectorDelegate> delegate;
@property (strong, nonatomic) Chatroom *stagedChatroom;

- (void)highlightChatroom:(Chatroom *)chatroom;

@end
