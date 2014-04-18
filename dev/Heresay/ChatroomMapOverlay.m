//
//  ChatroomMapOverlay.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/15/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomMapOverlay.h"

@implementation ChatroomMapOverlay

- (instancetype)initWithChatroom:(Chatroom *)chatroom {
	self = [super init];
	
	self.chatroom = chatroom;
	self.overlay = [self createOverlayWithChatroom:chatroom];
	self.overlayRenderer = [self createOverlayRendererWithOverlay:self.overlay];
	
	return self;
}

- (MKPolygon *)createOverlayWithChatroom:(Chatroom *)chatroom {
	CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(chatroom.geolocation.latitude, chatroom.geolocation.longitude);
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, [chatroom.radius doubleValue], [chatroom.radius doubleValue]);
	
	int numCoords = 4;
	CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * numCoords);
	coords[0] = CLLocationCoordinate2DMake((region.center.latitude + 0.5*region.span.latitudeDelta), (region.center.longitude - 0.5*region.span.longitudeDelta));
	coords[1] = CLLocationCoordinate2DMake((region.center.latitude + 0.5*region.span.latitudeDelta), (region.center.longitude + 0.5*region.span.longitudeDelta));
	coords[2] = CLLocationCoordinate2DMake((region.center.latitude - 0.5*region.span.latitudeDelta), (region.center.longitude + 0.5*region.span.longitudeDelta));
	coords[3] = CLLocationCoordinate2DMake((region.center.latitude - 0.5*region.span.latitudeDelta), (region.center.longitude - 0.5*region.span.longitudeDelta));
	
	MKPolygon *overlay = [MKPolygon polygonWithCoordinates:coords count:numCoords];
	
	free(coords);
	
	return overlay;
}

- (MKPolygonRenderer *)createOverlayRendererWithOverlay:(MKPolygon *)overlay {
	MKPolygonRenderer *overlayRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
	overlayRenderer.lineWidth = 2;
	overlayRenderer.strokeColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
	overlayRenderer.fillColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.5];
	overlayRenderer.alpha = 1.0;
	return overlayRenderer;
}


@end
