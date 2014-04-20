//
//  ChatroomContainerViewController.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
#import "ChatroomSelectorDelegate.h"
#import "ModalViewControllerDelegate.h"

@interface ChatroomContainerViewController : UIViewController <	/*UIViewControllerTransitioningDelegate,
																UIViewControllerAnimatedTransitioning,
																UIViewControllerInteractiveTransitioning,*/
																UIGestureRecognizerDelegate,
																ModalViewControllerDelegate,
																ChatroomSelectorDelegate >

/*
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
*/

@end
