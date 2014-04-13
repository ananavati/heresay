//
//  ChatroomTabBarController.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/12/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
#import "ChatroomSelectorDelegate.h"
#import "ModalViewControllerDelegate.h"

@interface ChatroomTabBarController : UITabBarController <UITabBarControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, ModalViewControllerDelegate, ChatroomSelectorDelegate>

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController;
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;


@end
