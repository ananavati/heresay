//
//  IntroSlideViewController.h
//  Heresay
//
//  Created by Thomas Ezan on 4/20/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroSlide.h"

@interface IntroSlideViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;
@property (weak, nonatomic) IBOutlet UILabel *slideLabel;
@property (nonatomic, strong) IntroSlide *slide;

@end
