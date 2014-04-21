//
//  ChatroomMapOverlay.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/15/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomMapOverlay.h"
#import "ChatroomMapOverlayRenderer.h"

@implementation ChatroomMapOverlay

- (instancetype)initWithChatroom:(Chatroom *)chatroom style:(NSInteger)style {
	self = [super init];
	
	_style = style;
	self.chatroom = chatroom;
	
	return self;
}

- (void)setChatroom:(Chatroom *)chatroom {
	_chatroom = chatroom;
	self.overlay = [self createOverlayWithChatroom:chatroom];
	self.overlayRenderer = [self createOverlayRendererWithOverlay:self.overlay];
	if (!self.style) {
		self.style = ChatroomMapOverlayStyleExisting;
	} else {
		self.style = self.style;
	}
}

- (void)setStyle:(ChatroomMapOverlayStyle)style {
	switch (style) {
		case ChatroomMapOverlayStyleExisting:
			self.overlayRenderer.lineWidth = 1;
			self.overlayRenderer.strokeColor = [UIColor colorWithRed:104.0/255.0 green:185.0/255.0 blue:199.0/255.0 alpha:1.0];
			self.overlayRenderer.fillColor = [UIColor colorWithRed:226.0/255.0 green:240.0/255.0 blue:234.0/255.0 alpha:0.65];
			break;
		case ChatroomMapOverlayStyleNew:
			self.overlayRenderer.lineWidth = 2;
			self.overlayRenderer.strokeColor = [UIColor colorWithRed:97.0/255.0 green:116.0/255.0 blue:114.0/255.0 alpha:1.0];
			self.overlayRenderer.fillColor = [UIColor colorWithRed:135.0/255.0 green:224.0/255.0 blue:217.0/255.0 alpha:0.65];
			break;
		case ChatroomMapOverlayStyleHighlighted:
			self.overlayRenderer.lineWidth = 1;
			self.overlayRenderer.strokeColor = [UIColor colorWithRed:97.0/255.0 green:116.0/255.0 blue:114.0/255.0 alpha:1.0];
			self.overlayRenderer.fillColor = [UIColor colorWithRed:135.0/255.0 green:224.0/255.0 blue:217.0/255.0 alpha:0.65];
			break;
		case ChatroomMapOverlayStyleGhosted:
			self.overlayRenderer.lineWidth = 1;
			self.overlayRenderer.strokeColor = [UIColor colorWithRed:142.0/255.0 green:170.0/255.0 blue:168.0/255.0 alpha:0.75];
			self.overlayRenderer.fillColor = [UIColor colorWithRed:193.0/255.0 green:211.0/255.0 blue:209.0/255.0 alpha:0.35];
			break;
	}

//	[self.overlayRenderer setNeedsDisplayInMapRect:self.overlay.boundingMapRect];
	
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

- (ChatroomMapOverlayRenderer *)createOverlayRendererWithOverlay:(MKPolygon *)overlay {
	ChatroomMapOverlayRenderer *overlayRenderer = [[ChatroomMapOverlayRenderer alloc] initWithPolygon:overlay];
	return overlayRenderer;
}


@end
