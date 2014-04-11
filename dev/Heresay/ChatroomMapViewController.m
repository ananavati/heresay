//
//  ChatroomMapViewController.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomMapViewController.h"

@interface ChatroomMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
}

- (void)viewDidAppear:(BOOL)animated {
	self.mapView.showsUserLocation = YES;
	
	/*
	MKCoordinateRegion region;
	MKUserLocation* userLocation = self.mapView.userLocation;
	region.center.latitude = userLocation.location.coordinate.latitude;
	region.center.longitude = userLocation.location.coordinate.longitude;
	region.span.latitudeDelta = 20.0;
	region.span.longitudeDelta = 28.0;
	[self.mapView setRegion:region animated:YES];
	 */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	MKCoordinateRegion region;
//	MKUserLocation* userLocation = self.mapView.userLocation;
	region.center.latitude = userLocation.location.coordinate.latitude;
	region.center.longitude = userLocation.location.coordinate.longitude;
	region.span.latitudeDelta = 20.0;
	region.span.longitudeDelta = 28.0;
	[self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation == mapView.userLocation) {
			MKCoordinateRegion region;
			MKCoordinateSpan span;

			span.latitudeDelta=0.1;
			span.longitudeDelta=0.1;

			CLLocationCoordinate2D location=mapView.userLocation.coordinate;

			region.span=span;
			region.center=location;

			[mapView setRegion:region animated:TRUE];
			[mapView regionThatFits:region];
		}
	}
}
*/

@end
