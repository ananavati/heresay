//
//  ChatroomMapOverlayRenderer.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/20/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomMapOverlayRenderer.h"

@implementation ChatroomMapOverlayRenderer

- (instancetype)initWithPolygon:(MKPolygon *)polygon {
	self = [super initWithPolygon:polygon];
	self.lineWidth = 1;
	self.alpha = 1.0;
	return self;
}
/*
-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
	[super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
}
*/
@end
