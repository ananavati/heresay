//
//  ChatroomTabBarController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/12/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomTabBarController.h"
#import "ChatroomListViewController.h"
#import "ChatroomMapViewController.h"
#import "MainSettingsViewController.h"
#import "LoginViewController.h"
#import "LocationManager.h"

@interface ChatroomTabBarController ()

@property (strong, nonatomic) ChatroomListViewController *chatroomListViewController;
@property (strong, nonatomic) ChatroomMapViewController *chatroomMapViewController;
@property (strong, nonatomic) MainSettingsViewController *mainSettingsViewController;
@property (strong, nonatomic) IntroViewController *introViewController;

@property (assign, nonatomic) BOOL introComplete;

@end

@implementation ChatroomTabBarController {
	int tabTransitionStyle;
	NSTimeInterval tabTransitionDuration;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		tabTransitionStyle = 1;			// 1 = slide, 2 = flip
		tabTransitionDuration = tabTransitionStyle == 1 ? 0.35 : 0.75;
		
		
		// Tab bar setup
		self.chatroomListViewController = [[ChatroomListViewController alloc] init];
		self.chatroomListViewController.delegate = self;
		self.chatroomListViewController.title = @"List";
//		self.chatroomListViewController.tabBarItem.image = [UIImage imageNamed:@"chatroomList.png"];
		
		self.chatroomMapViewController = [[ChatroomMapViewController alloc] init];
		self.chatroomMapViewController.delegate = self;
		self.chatroomMapViewController.title = @"Map";
//		self.chatroomMapViewController.tabBarItem.image = [UIImage imageNamed:@"chatroomMap.png"];
		
		self.viewControllers = @[self.chatroomListViewController, self.chatroomMapViewController];
		self.delegate = self;
		
		
		// Set up other view controllers
		self.mainSettingsViewController = [[MainSettingsViewController alloc] init];
		
		self.introViewController = [[IntroViewController alloc] init];
		self.introViewController.delegate = self;
		
	}
	
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
	
	// Navigation Bar setup
	self.title = @"Nearby Chats";
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsTapped:)];
	rightButton.tintColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
	self.navigationItem.rightBarButtonItem = rightButton;
	
	// Display the intro only if the user has not already enabled location services for the app.
	if (![[LocationManager instance] locationServicesEnabled]) {
		[self performSelector:@selector(presentIntro) withObject:nil afterDelay:0];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



- (void)presentIntro {
	if (self.introComplete) { return; }
	[self.navigationController presentViewController:self.introViewController animated:YES completion:nil];
}

- (void)settingsTapped:(id)sender {
	[self.navigationController pushViewController:self.mainSettingsViewController animated:YES];
}

- (void)didDismissWithViewController:(UIViewController *)viewController {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	
	if (viewController == self.introViewController) {
		self.introComplete = YES;
	}
}

- (void)didSelectChatroom:(id)chatroomSelector withChatroom:(Chatroom *)chatroom {
	// TODO: LoginViewController if not authed, else straight to ChatroomViewController
	LoginViewController *loginViewController = [[LoginViewController alloc] init];
	loginViewController.chatroom = chatroom;
	
	[self.navigationController pushViewController:loginViewController animated:YES];
}



#pragma mark - UITabBarControllerDelegate implementation

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
	return self;
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
	return self;
}

// Interactive tab bar transitions (when tab bar button is tapped)
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	[self performTabTransition:transitionContext];
}

// Programmatic tab bar transitions (when setting tab via code)
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	[self performTabTransition:transitionContext];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return tabTransitionDuration;
}

- (void)performTabTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIView *containerView = [transitionContext containerView];
	UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	CGSize appSize = [[UIScreen mainScreen] bounds].size;
	UIViewAnimationOptions animationOptions;
	
	if (tabTransitionStyle == 1) {
		
		// horizontal slide transition
		
		if (toVC == self.chatroomListViewController) {
			// slide Chatroom list in from left
			toVC.view.frame = CGRectMake(-appSize.width, 0, appSize.width, appSize.height);
			animationOptions = UIViewAnimationOptionCurveEaseOut;
		} else if (toVC == self.chatroomMapViewController) {
			// slide Chatroom map in from right
			toVC.view.frame = CGRectMake(appSize.width, 0, appSize.width, appSize.height);
			animationOptions = UIViewAnimationOptionCurveEaseOut;
		}
		
		[containerView addSubview:toVC.view];
		
		[UIView animateWithDuration:tabTransitionDuration delay:0 options:animationOptions animations:^{
			toVC.view.frame = CGRectMake(0, 0, appSize.width, appSize.height);
		} completion:^(BOOL finished){
			[transitionContext completeTransition:YES];
		}];
		
	} else if (tabTransitionStyle == 2) {
		
		// flip transition

		if (toVC == self.chatroomListViewController) {
			// flip Chatroom list in from right
			animationOptions = UIViewAnimationOptionTransitionFlipFromLeft;
		} else if (toVC == self.chatroomMapViewController) {
			// flip Chatroom map in from left
			animationOptions = UIViewAnimationOptionTransitionFlipFromRight;
		}
		
		[UIView transitionWithView:containerView duration:tabTransitionDuration options:animationOptions animations:^{
			[fromVC.view removeFromSuperview];
			[containerView addSubview:toVC.view];
		} completion:^(BOOL finished){
			[transitionContext completeTransition:YES];
		}];
	}
	
}


@end
