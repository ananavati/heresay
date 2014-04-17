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
@property (strong, nonatomic) NSArray *nearbyChatrooms;

@end


@implementation ChatroomMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.mapView.delegate = self;
	self.mapView.showsUserLocation = YES;
//	NSLog(@"viewDidLoad userLoc:%f,%f", self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
}

- (void)viewWillAppear:(BOOL)animated {
//	NSLog(@"viewWillAppear userLoc:%f,%f", self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
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
//	NSLog(@"didUpdateUserLoc userLoc:%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	[self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation == mapView.userLocation) {
			
//			NSLog(@"didAddAnnView userLoc:%f,%f", self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
			[[ChatRoomApi instance] fetchChatroomsNearLocation:self.mapView.userLocation.location withSuccess:^(NSArray *chatrooms) {
				self.nearbyChatrooms = chatrooms;
			}];
			
			// Zoom into current location once it's obtained
			MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate, 1000, 1000);
			[self.mapView setRegion:region animated:YES];
		}
	}
}

- (void)setNearbyChatrooms:(NSArray *)nearbyChatrooms {
	_nearbyChatrooms = nearbyChatrooms;
	
	for (Chatroom *chatroom in nearbyChatrooms) {
		
		CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(chatroom.geolocation.latitude, chatroom.geolocation.longitude);
		MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, [chatroom.radius doubleValue], [chatroom.radius doubleValue]);
		
		int numCoords = 4;
		CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * numCoords);
		coords[0] = CLLocationCoordinate2DMake((region.center.latitude + 0.5*region.span.latitudeDelta), (region.center.longitude - 0.5*region.span.longitudeDelta));
		coords[1] = CLLocationCoordinate2DMake((region.center.latitude + 0.5*region.span.latitudeDelta), (region.center.longitude + 0.5*region.span.longitudeDelta));
		coords[2] = CLLocationCoordinate2DMake((region.center.latitude - 0.5*region.span.latitudeDelta), (region.center.longitude + 0.5*region.span.longitudeDelta));
		coords[3] = CLLocationCoordinate2DMake((region.center.latitude - 0.5*region.span.latitudeDelta), (region.center.longitude - 0.5*region.span.longitudeDelta));
		MKPolygon *chatroomPolygon = [MKPolygon polygonWithCoordinates:coords count:numCoords];
		free(coords);
		
//		chatroomPolygon.coordinate = CLLocationCoordinate2DMake(chatroom.geolocation.latitude, chatroom.geolocation.longitude);
		//	NSLog(@"pts per meter:%f", MKMapPointsPerMeterAtLatitude(chatroom.geolocation.latitude));
//		double radiusInPoints = MKMapPointsPerMeterAtLatitude(chatroom.geolocation.latitude) * [chatroom.radius doubleValue];
//		chatroomPolygon.boundingMapRect = MKMapRectMake(chatroom.geolocation.latitude, chatroom.geolocation.longitude, radiusInPoints, radiusInPoints);
		
		
		[self.mapView addOverlay:chatroomPolygon];
		
		NSLog(@"overlays:%i",self.mapView.overlays.count);
		
		
		
//		ChatroomMapOverlay *chatroomOverlay = [[ChatroomMapOverlay alloc] initWithChatroom:chatroom];
//		[self.mapView addOverlay:chatroomOverlay];
	}
	
	// TODO: support interaction with MKPolygonRenderer
	// http://stackoverflow.com/questions/20858108/detecting-touches-on-mkoverlay-in-ios7-mkoverlayrenderer
	// http://stackoverflow.com/questions/18477443/detecting-tap-on-mkpolygonview-in-mkmapview-on-ios7
	// http://stackoverflow.com/questions/19014926/detecting-a-point-in-a-mkpolygon-broke-with-ios7-cgpathcontainspoint
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
	NSLog(@"rendererForOverlay:()");
	
	// TODO: better to update instead of recreate?
	MKPolygonRenderer *chatroomRenderer = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
//	MKPolygonRenderer *chatroomRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
	chatroomRenderer.lineWidth = 2;
	chatroomRenderer.strokeColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
	chatroomRenderer.fillColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.5];
	chatroomRenderer.alpha = 1.0;
//	[chatroomRenderer invalidatePath];
	return chatroomRenderer;
}


@end
