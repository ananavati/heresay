//
//  ChatroomCardsViewController.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatroomSelectorDelegate.h"

@interface ChatroomCardsViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *chatroomModels;
@property (strong, nonatomic) id<ChatroomSelectorDelegate> delegate;

- (void)highlightChatroom:(Chatroom *)chatroom;

@end
