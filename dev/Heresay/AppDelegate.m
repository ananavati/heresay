//
//  AppDelegate.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/2/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatroomContainerViewController.h"

#import <Parse/Parse.h>

#import "User.h"
#import "Chatroom.h"
#import "Message.h"

@interface AppDelegate ()

@property (strong, nonatomic) ChatroomContainerViewController *chatroomContainerViewController;

@end

#define PARSE_APP_ID @"IN6rYCqD0rj7fHAYQgLZq8L6ZcYvmB2CmCUuJkdu"
#define PARSE_CLIENT_KEY @"TtRImMMV88XMElru11arvlgRBYdkk6dUD3FsDw9P"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_KEY];
    [self registerParseSubClasses];
    
	self.chatroomContainerViewController = [[ChatroomContainerViewController alloc] init];
	UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:self.chatroomContainerViewController];
	self.window.rootViewController = mainNavigationController;
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) registerParseSubClasses {
    [User registerSubclass];
    [Chatroom registerSubclass];
    [Message registerSubclass];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
