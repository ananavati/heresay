//
//  IntroViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "IntroViewController.h"
#import "LocationManager.h"

@interface IntroViewController ()

- (IBAction)onEnableLocationServicesButtonTapped:(id)sender;
@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEnableLocationServicesButtonTapped:(id)sender {
	[[LocationManager instance] enableLocationServicesWithResult:^(BOOL allowed) {
		if (!allowed) {
			// TODO: Message user: No location services? No Heresay.
			//		 Here's how to enable it when you're ready to use it.
		} else {
			[self.delegate didDismissModalViewController:self];
		}
	}];
}

@end
