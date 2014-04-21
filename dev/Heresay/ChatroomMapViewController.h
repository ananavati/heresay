//
//  ChatroomMapViewController.h
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ChatroomSelectorDelegate.h"

@interface ChatroomMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSArray *chatroomModels;
@property (strong, nonatomic) id<ChatroomSelectorDelegate> delegate;
@property (strong, nonatomic) Chatroom *stagedChatroom;

- (void)showUserLocation;
- (void)highlightChatroom:(Chatroom *)chatroom;

@end
