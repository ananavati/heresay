//
//  ChatroomSelectorDelegate.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chatroom.h"

@protocol ChatroomSelectorDelegate <NSObject>

@required
- (void)chatroomSelector:(id)chatroomSelector didHighlightChatroom:(Chatroom *)chatroom;
- (void)chatroomSelector:(id)chatroomSelector didSelectChatroom:(Chatroom *)chatroom;
- (void)chatroomSelector:(id)chatroomSelector didStageNewChatroom:(Chatroom *)chatroom;
- (void)chatroomSelectorDidAbortNewChatroom:(id)chatroomSelector;
- (void)chatroomSelectorDidConfirmNewChatroom:(id)chatroomSelector;
- (void)chatroomSelectorDidCancelNewChatroom:(id)chatroomSelector;

@end

@interface ChatroomSelectorDelegate : NSObject

@end
