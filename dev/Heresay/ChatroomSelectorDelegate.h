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

- (void)didSelectChatroom:(id)chatroomSelector withChatroom:(Chatroom *)chatroom;

@end

@interface ChatroomSelectorDelegate : NSObject

@end
