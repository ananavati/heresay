//
//  ChatroomMapViewController.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomMapViewController.h"
#import "ChatRoomApi.h"
#import "ChatroomMapOverlay.h"

@interface ChatroomMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *chatroomOverlays;
@property (strong, nonatomic) NSMutableArray *chatroomMapOverlays;

@end


@implementation ChatroomMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		self.chatroomOverlays = [[NSMutableArray alloc] init];
		self.chatroomMapOverlays = [[NSMutableArray alloc] init];
	}
	
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.mapView.delegate = self;
	self.mapView.showsUserLocation = YES;
	
	UITapGestureRecognizer *mapTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMapViewTapped:)];
	mapTapGestureRecognizer.cancelsTouchesInView = NO;
	mapTapGestureRecognizer.numberOfTapsRequired = 1;
	[self.mapView addGestureRecognizer:mapTapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
	//
}

- (void)viewDidAppear:(BOOL)animated {
	//
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//	NSLog(@"mapView didUpdateUserLoc userLoc:%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	[self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation == mapView.userLocation) {
			
//			NSLog(@"didAddAnnView userLoc:%f,%f", self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
			
			// Zoom into current location once it's obtained
			MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, 1000, 1000);
			[self.mapView setRegion:region animated:YES];
		}
	}
}

- (void)setChatroomModels:(NSArray *)chatroomModels {
	_chatroomModels = chatroomModels;
	
	for (Chatroom *chatroom in chatroomModels) {
		
		ChatroomMapOverlay *chatroomOverlay = [[ChatroomMapOverlay alloc] initWithChatroom:chatroom];
		
		// Associate ChatroomMapOverlay object with its MKOverlay object,
		// to retrieve MKOverlayRenderer from MKOverlay in mapView:rendererForOverlay.
		// This is a kludge, but couldn't figure out a better way to retrieve
		// the renderer given the overlay...
		[self.chatroomOverlays addObject:chatroomOverlay.overlay];
		[self.chatroomMapOverlays addObject:chatroomOverlay];
		
		[self.mapView addOverlay:chatroomOverlay.overlay];
	}
	
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
	int overlayIndex = [self.chatroomOverlays indexOfObject:overlay];
	if (overlayIndex == -1) { return nil; }
	
	return ((ChatroomMapOverlay *)(self.chatroomMapOverlays[overlayIndex])).overlayRenderer;
}

// Implementation from:
// http://stackoverflow.com/questions/20858108/detecting-touches-on-mkoverlay-in-ios7-mkoverlayrenderer
- (void)onMapViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
	
	// TODO: optimize by testing only polygons in view
	
	CGPoint tapPoint = [tapGestureRecognizer locationInView:self.mapView];
	CLLocationCoordinate2D tapCoordinate = [self.mapView convertPoint:tapPoint toCoordinateFromView:self.mapView];
	MKMapPoint mapCoordinate = MKMapPointForCoordinate(tapCoordinate);
	CGPoint mapPoint = CGPointMake(mapCoordinate.x, mapCoordinate.y);
	
	for (ChatroomMapOverlay *chatroomMapOverlay in self.chatroomMapOverlays) {
		MKPolygon *polygon = chatroomMapOverlay.overlay;
		CGMutablePathRef pathRef = CGPathCreateMutable();
		MKMapPoint *polygonPoints = polygon.points;
		
		for (int i=0; i<polygon.pointCount; i++) {
			MKMapPoint pt = polygonPoints[i];
			if (i == 0) {
				CGPathMoveToPoint(pathRef, NULL, pt.x, pt.y);
			} else {
				CGPathAddLineToPoint(pathRef, NULL, pt.x, pt.y);
			}
			
			if (CGPathContainsPoint(pathRef, NULL, mapPoint, FALSE)) {
				NSLog(@"tapped in chatroom:%@", chatroomMapOverlay.chatroom);
			}
		}
	}
}

@end
