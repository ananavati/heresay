//
//  IntroViewController.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroViewController;
@protocol IntroDelegate <NSObject>

- (void)didCompleteIntroWithIntroViewController:(IntroViewController *)introViewController;

@end

@interface IntroViewController : UIViewController

@property (strong, nonatomic) id<IntroDelegate> delegate;

@end
