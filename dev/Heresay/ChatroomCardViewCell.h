//
//  ChatroomCardViewCell.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chatroom.h"

@class ChatroomCardViewCell;
@protocol ChatroomCardViewDelegate <NSObject>

- (void)chatroomCardViewDidConfirm:(ChatroomCardViewCell *)chatroomCardView;
- (void)chatroomCardViewDidCancel:(ChatroomCardViewCell *)chatroomCardView;

@end


@interface ChatroomCardViewCell : UICollectionViewCell

@property (strong, nonatomic) id<ChatroomCardViewDelegate> delegate;
@property (assign, nonatomic) BOOL isNewChatroom;
- (void)initWithModel:(Chatroom *)model;
- (CGSize)calcSizeWithModel:(Chatroom *)model;

@end
