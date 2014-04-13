//
//  LoginViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/11/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *chatroomNameLabel;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
	if (self.chatroom) {
		self.chatroomNameLabel.text = self.chatroom.name;
	} else {
		self.chatroomNameLabel.text = @"New Chatroom";
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
