//
//  ChatroomMapOverlay.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/15/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomMapOverlay.h"

@implementation ChatroomMapOverlay

// Required by MKOverlay protocol
@synthesize coordinate,
			boundingMapRect;

- (instancetype)initWithChatroom:(Chatroom *)chatroom {
	self = [super init];
	
	coordinate = CLLocationCoordinate2DMake(chatroom.geolocation.latitude, chatroom.geolocation.longitude);
	MKMapPoint centerPoint = MKMapPointForCoordinate(coordinate);
//	NSLog(@"pts per meter:%f", MKMapPointsPerMeterAtLatitude(chatroom.geolocation.latitude));
	double radiusInPoints = MKMapPointsPerMeterAtLatitude(chatroom.geolocation.latitude) * [chatroom.radius doubleValue];
//	boundingMapRect = MKMapRectMake(chatroom.geolocation.latitude, chatroom.geolocation.longitude, radiusInPoints, radiusInPoints);
	boundingMapRect = MKMapRectMake(centerPoint.x, centerPoint.y, radiusInPoints, radiusInPoints);
	
	/*
	CLLocationCoordinate2D overlayTopLeftCoordinate = CLLocationCoordinate2DMake(37.763599494827744, -122.50571723969188);
	CLLocationCoordinate2D overlayTopRightCoordinate = CLLocationCoordinate2DMake(37.763718237405826, -122.5037216761848);
	CLLocationCoordinate2D overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(37.7614875414135, -122.50565286667552);
	
	MKMapPoint topLeft = MKMapPointForCoordinate(overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(overlayBottomLeftCoordinate);
	
	coordinate = CLLocationCoordinate2DMake(topRight.y - bottomLeft.y, topRight.x - bottomLeft.x);
	
    boundingMapRect = MKMapRectMake(topLeft.x,
						 topLeft.y,
						 fabs(topLeft.x - topRight.x),
						 fabs(topLeft.y - bottomLeft.y));
	*/
	
	return self;
}

@end
