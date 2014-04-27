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

typedef struct {
	CLLocationCoordinate2D center;
	CLLocationCoordinate2D ne;
	CLLocationCoordinate2D sw;
} GeoQueryBounds;

@protocol MapUpdateDelegate <NSObject>

- (void)map:(id)mapViewController didStopAtBounds:(GeoQueryBounds)bounds;

@end

@interface ChatroomMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSMutableArray *chatroomModels;
@property (strong, nonatomic) id<ChatroomSelectorDelegate> delegate;
@property (strong, nonatomic) id<MapUpdateDelegate> mapUpdateDelegate;
@property (strong, nonatomic) Chatroom *stagedChatroom;
@property (assign, nonatomic) GeoQueryBounds stationaryMapBounds;

- (void)showUserLocation;
- (void)highlightChatroom:(Chatroom *)chatroom;

@end
