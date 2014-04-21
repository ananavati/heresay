//
//  IntroSlideViewController.m
//  Heresay
//
//  Created by Thomas Ezan on 4/20/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "IntroSlideViewController.h"

@interface IntroSlideViewController ()

@end

@implementation IntroSlideViewController

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
    self.slideImageView.image = [UIImage imageNamed:self.slide.imageName];
    self.slideLabel.text = self.slide.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
