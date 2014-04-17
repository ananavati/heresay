//
//  ChatroomMapOverlay.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/15/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Chatroom.h"

@interface ChatroomMapOverlay : NSObject <MKOverlay>

- (instancetype)initWithChatroom:(Chatroom *)chatroom;

@end
