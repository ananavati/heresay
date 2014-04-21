//
//  ChatroomMapOverlayRenderer.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/20/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ChatroomMapOverlayRenderer : MKPolygonRenderer

- (instancetype)initWithPolygon:(MKPolygon *)polygon;

@end
