//
//  MainViewController.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
#import "ChatroomSelectorDelegate.h"

@interface MainViewController : UIViewController <IntroDelegate, ChatroomSelectorDelegate>

@end
