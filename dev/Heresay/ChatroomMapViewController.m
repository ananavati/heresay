//
//  ChatroomMapViewController.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <MBXMapKit/MBXMapKit.h>
#import "ChatroomMapViewController.h"
#import "ChatRoomApi.h"
#import "ChatroomMapOverlay.h"
#import "AppConstants.h"

@interface ChatroomMapViewController ()

@property (strong, nonatomic) MBXMapView *mapView;

@property (strong, nonatomic) NSMutableArray *chatroomOverlays;
@property (strong, nonatomic) NSMutableArray *chatroomMapOverlays;
@property (strong, nonatomic) id<MKOverlay> stagedChatroomOverlay;
@property (strong, nonatomic) ChatroomMapOverlay *stagedChatroomMapOverlay;

@property (weak, nonatomic) IBOutlet UISegmentedControl *chatroomSizeControl;
- (IBAction)chatroomSizeControlValueChanged:(id)sender;

@end

// MBXMapViewTileOverlay is not recognized at compile time, so doing this instead...
static Class MAPBOX_TILE_CLASS;

@implementation ChatroomMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		self.chatroomOverlays = [[NSMutableArray alloc] init];
		self.chatroomMapOverlays = [[NSMutableArray alloc] init];
		
		MAPBOX_TILE_CLASS = NSClassFromString(@"MBXMapViewTileOverlay");
	}
	
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.mapView = [[MBXMapView alloc] initWithFrame:self.view.frame mapID:@"ericsoco.i1e8759o"];
	self.mapView.delegate = self;
	self.mapView.showsBuildings = YES;
	[self.view addSubview:self.mapView];
	
	UITapGestureRecognizer *mapTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMapViewTapped:)];
	mapTapGestureRecognizer.cancelsTouchesInView = NO;
	mapTapGestureRecognizer.numberOfTapsRequired = 1;
	[self.mapView addGestureRecognizer:mapTapGestureRecognizer];
	
	/*
	// attempting to eliminate delay on single tap recognition...
	UITapGestureRecognizer *mapDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMapViewDoubleTapped:)];
	mapDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
	[mapDoubleTapGestureRecognizer requireGestureRecognizerToFail:mapTapGestureRecognizer];
	[self.mapView addGestureRecognizer:mapDoubleTapGestureRecognizer];
	*/
	
	self.chatroomSizeControl.hidden = YES;
	[self.view bringSubviewToFront:self.chatroomSizeControl];
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

- (void)showUserLocation {
	self.mapView.showsUserLocation = YES;
}

- (void)highlightChatroom:(Chatroom *)chatroom {
	// TODO: this is totally unoptimized.
	ChatroomMapOverlay *overlay;
	Chatroom *chatroomModel;
	for (int i=0; i<self.chatroomModels.count; i++) {
		chatroomModel = self.chatroomModels[i];
		overlay = self.chatroomMapOverlays[i];
		if (chatroomModel == chatroom) {
			overlay.style = ChatroomMapOverlayStyleHighlighted;
		} else {
			overlay.style = ChatroomMapOverlayStyleExisting;
		}
	}
}

- (void)setChatroomModels:(NSArray *)chatroomModels {
	_chatroomModels = chatroomModels;
	
	for (Chatroom *chatroom in chatroomModels) {
		ChatroomMapOverlay *chatroomOverlay = [[ChatroomMapOverlay alloc] initWithChatroom:chatroom style:ChatroomMapOverlayStyleExisting];
		
		// Associate ChatroomMapOverlay object with its MKOverlay object,
		// to retrieve MKOverlayRenderer from MKOverlay in mapView:rendererForOverlay.
		// This is a kludge, but couldn't figure out a better way to retrieve
		// the renderer given the overlay...
		[self.chatroomOverlays addObject:chatroomOverlay.overlay];
		[self.chatroomMapOverlays addObject:chatroomOverlay];
		
		[self.mapView addOverlay:chatroomOverlay.overlay];
	}
}



#pragma mark - New Chat UI
- (void)onNewChatTapped {
	self.chatroomSizeControl.hidden = NO;
	self.chatroomSizeControl.alpha = 0.0;
	[UIView animateWithDuration:0.5 animations:^{
		self.chatroomSizeControl.alpha = 1.0;
	}];
	
	Chatroom *newChatroom = [[Chatroom alloc] init];
	newChatroom.chatRoomName = @"New Chat";
	newChatroom.radius = [NSNumber numberWithDouble:CHATROOM_SIZE_LARGE];
	[newChatroom setLocation:self.mapView.userLocation.location.coordinate];
	[self.delegate chatroomSelector:self didStageNewChatroom:newChatroom];
}

- (void)setStagedChatroom:(Chatroom *)stagedChatroom {
	_stagedChatroom = stagedChatroom;
	
	if (stagedChatroom && !self.stagedChatroomOverlay) {
		
		// add new staged chatroom
		ChatroomMapOverlay *chatroomOverlay = [[ChatroomMapOverlay alloc] initWithChatroom:stagedChatroom style:ChatroomMapOverlayStyleNew];
		chatroomOverlay.style = ChatroomMapOverlayStyleNew;
		
		self.stagedChatroomOverlay = chatroomOverlay.overlay;
		self.stagedChatroomMapOverlay = chatroomOverlay;
		[self.mapView addOverlay:self.stagedChatroomOverlay];
		
	} else if (self.stagedChatroomOverlay) {
		
		if (!stagedChatroom) {
			// remove existing staged chatroom
			[self.mapView removeOverlay:self.stagedChatroomOverlay];
			self.stagedChatroomOverlay = nil;
			self.stagedChatroomMapOverlay = nil;
		} else {
			NSLog(@"update overlay");
			// update existing staged chatroom
			[self.mapView removeOverlay:self.stagedChatroomOverlay];
			self.stagedChatroomMapOverlay.chatroom = self.stagedChatroom;
			self.stagedChatroomOverlay = self.stagedChatroomMapOverlay.overlay;
			[self.mapView addOverlay:self.stagedChatroomOverlay];
		}
		
	}
}

- (IBAction)chatroomSizeControlValueChanged:(id)sender {
	// TODO: this would be better with a constant array of doubles,
	//		 but couldn't figure out syntax...
	double radius = 0.0;
	switch (self.chatroomSizeControl.selectedSegmentIndex) {
		case 0:
			radius = CHATROOM_SIZE_SMALL;
			break;
		case 1:
			radius = CHATROOM_SIZE_MEDIUM;
			break;
		case 2:
			radius = CHATROOM_SIZE_LARGE;
			break;
		case 3:
			radius = CHATROOM_SIZE_XLARGE;
			break;
	}
	self.stagedChatroom.radius = [NSNumber numberWithDouble:radius];
	[self.delegate chatroomSelector:self didStageNewChatroom:self.stagedChatroom];
}



#pragma mark - MapView delegate implementation
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	//	NSLog(@"mapView didUpdateUserLoc userLoc:%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	[self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation == mapView.userLocation) {
			
			// custom user location annotation
			// TODO: move into nib?
			annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
			[((UIButton *)(annotationView.rightCalloutAccessoryView)) addTarget:self action:@selector(onNewChatTapped) forControlEvents:UIControlEventTouchUpInside];
			
			// Zoom into current location once it's obtained
			MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, 1.1*CHATROOM_SIZE_XLARGE, 1.1*CHATROOM_SIZE_XLARGE);
			[self.mapView setRegion:region animated:YES];
		} else {
			// hide MapBox HQ annotation
			annotationView.hidden = YES;
		}
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if (annotation == mapView.userLocation) {
		mapView.userLocation.title = @"New Chat"; // @"Create New Chat Here";
		mapView.userLocation.subtitle = @"200m";
	}
	return nil;
	
	// TODO: customize annotations
	/*
	 MKAnnotationView *customAnnotationView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil] autorelease];
	 UIImage *pinImage = [UIImage imageNamed:@"ReplacementPinImage.png"];
	 [customAnnotationView setImage:pinImage];
	 customAnnotationView.canShowCallout = YES;
	 return customAnnotationView;
	 */
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if (view.annotation == mapView.userLocation) {
		[self onNewChatTapped];
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	if (view.annotation == mapView.userLocation) {
		[self.delegate chatroomSelectorDidAbortNewChatroom:self];
		
		[UIView animateWithDuration:0.5 animations:^{
			self.chatroomSizeControl.alpha = 0.0;
		} completion:^(BOOL finished) {
			self.chatroomSizeControl.hidden = YES;
		}];
	}
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
	
	// return nil for MapBox tile overlays
	// MBXMapViewTileOverlay is not recognized at compile time, so doing this instead...
//	if ([overlay isKindOfClass:[MBXMapViewTileOverlay class]]) { return nil; }
	if ([overlay class] == MAPBOX_TILE_CLASS) { return nil; }
	
	// renderer for staged new chatroom
	if (overlay == self.stagedChatroomOverlay) {
		NSLog(@"renderer for staged overlay");
		return self.stagedChatroomMapOverlay.overlayRenderer;
	}
	
	// renderer for existing chatroom
	NSUInteger overlayIndex = [self.chatroomOverlays indexOfObject:overlay];
	if (overlayIndex == NSNotFound) { return nil; }
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
				[self highlightChatroom:chatroomMapOverlay.chatroom];
				[self.delegate chatroomSelector:self didHighlightChatroom:chatroomMapOverlay.chatroom];
			}
		}
	}
}

/*
- (void)onMapViewDoubleTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
	NSLog(@"swallow doubletap");
}
*/

@end
