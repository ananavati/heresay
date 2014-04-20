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
	self.strokeColor = [UIColor colorWithRed:104.0/255.0 green:185.0/255.0 blue:199.0/255.0 alpha:1.0];
	self.fillColor = [UIColor colorWithRed:226.0/255.0 green:240.0/255.0 blue:234.0/255.0 alpha:0.65];
	self.alpha = 1.0;
	return self;
}

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
	[super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
	
}

@end
