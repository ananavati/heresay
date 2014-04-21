//
//  IntroViewController.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewControllerDelegate.h"

@interface IntroViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) id<ModalViewControllerDelegate> delegate;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic) NSInteger vcIndex;

@end
