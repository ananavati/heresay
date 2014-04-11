//
//  MainViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "ChatroomListViewController.h"
#import "ChatroomMapViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) IntroViewController *introViewController;
@property (strong, nonatomic) ChatroomListViewController *chatroomListViewController;
@property (strong, nonatomic) ChatroomMapViewController *chatroomMapViewController;

// TODO: store in NSUserDefaults
@property (assign, nonatomic) BOOL introComplete;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.introViewController = [[IntroViewController alloc] init];
		self.introViewController.delegate = self;
		
		self.chatroomListViewController = [[ChatroomListViewController alloc] init];
		self.chatroomListViewController.delegate = self;
		self.chatroomListViewController.title = @"List";
//		self.chatroomListViewController.tabBarItem.image = @"chatroomList.png";
		
		self.chatroomMapViewController = [[ChatroomMapViewController alloc] init];
		self.chatroomMapViewController.delegate = self;
		self.chatroomMapViewController.title = @"Map";
//		self.chatroomMapViewController.tabBarItem.image = @"chatroomMap.png";
		
		self.tabBarController = [[UITabBarController alloc] init];
		self.tabBarController.viewControllers = @[
		  self.chatroomListViewController,
		  self.chatroomMapViewController
		];
		[self.view addSubview:self.tabBarController.view];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
	[self performSelector:@selector(presentIntro) withObject:nil afterDelay:0];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)presentIntro {
	if (self.introComplete) { return; }
	[self.navigationController presentViewController:self.introViewController animated:YES completion:nil];
}

- (void)didSelectChatroom:(id)chatroomSelector withChatroom:(Chatroom *)chatroom {
	// TODO: LoginViewController if not authed, else straight to ChatroomViewController
	LoginViewController *loginViewController = [[LoginViewController alloc] init];
	[self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)didCompleteIntroWithIntroViewController:(IntroViewController *)introViewController {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	self.introComplete = YES;
}

@end
