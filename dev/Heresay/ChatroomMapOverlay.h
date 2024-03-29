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
#import "ChatroomMapOverlayRenderer.h"

@interface ChatroomMapOverlay : NSObject

typedef NS_ENUM(NSInteger, ChatroomMapOverlayStyle) {
	ChatroomMapOverlayStyleExisting,
	ChatroomMapOverlayStyleNew,
	ChatroomMapOverlayStyleHighlighted,
	ChatroomMapOverlayStyleGhosted
};

@property (strong, nonatomic) Chatroom *chatroom;
@property (strong, nonatomic) MKCircle *overlay;
@property (strong, nonatomic) MKCircleRenderer *overlayRenderer;
@property (assign, nonatomic) ChatroomMapOverlayStyle style;

//@property (strong, nonatomic) MKPolygon *overlay;
//@property (strong, nonatomic) ChatroomMapOverlayRenderer *overlayRenderer;


- (instancetype)initWithChatroom:(Chatroom *)chatroom style:(NSInteger)style;

@end
