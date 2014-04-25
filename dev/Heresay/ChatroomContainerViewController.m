//
//  ChatroomContainerViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomContainerViewController.h"
#import "ChatroomMapViewController.h"
#import "ChatroomCardsViewController.h"
#import "ChatroomViewController.h"
#import "MainSettingsViewController.h"
#import "LoginViewController.h"
#import "LocationManager.h"
#import "ChatRoomApi.h"
#import "UserApi.h"


@interface ChatroomContainerViewController ()

@property (strong, nonatomic) ChatroomMapViewController *chatroomMapViewController;
@property (strong, nonatomic) ChatroomCardsViewController *chatroomCardsViewController;
@property (strong, nonatomic) MainSettingsViewController *mainSettingsViewController;
@property (strong, nonatomic) IntroViewController *introViewController;

@property (assign, nonatomic) BOOL introComplete;
@property (assign, nonatomic) BOOL cardsViewOpen;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;


@end


static double CARDS_VIEW_CLOSED_Y;
static const double CARDS_VIEW_OPEN_Y = 200.0;
static const double CARDS_VIEW_OPEN_FULL_Y = 0.0;
static const double CARDS_VIEW_ANIMATE_CLOSE_DURATION = 0.75;

@implementation ChatroomContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

	if (self) {
		
		// set up chatroom view controllers
		self.chatroomMapViewController = [[ChatroomMapViewController alloc] init];
		self.chatroomMapViewController.delegate = self;
		[self.view addSubview:self.chatroomMapViewController.view];
		
		self.chatroomCardsViewController = [[ChatroomCardsViewController alloc] init];
		self.chatroomCardsViewController.delegate = self;
		[self.view addSubview:self.chatroomCardsViewController.view];
		
		
		// set up other view controllers
		self.mainSettingsViewController = [[MainSettingsViewController alloc] init];
		
		self.introViewController = [[IntroViewController alloc] init];
		self.introViewController.delegate = self;
		
		// TODO: may have to attach to scrollView instead of self to avoid blocking scrollView panning?
		// http://stackoverflow.com/questions/13736399/intercepting-pan-gestures-over-a-uiscrollview-breaks-scrolling
		self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCardsViewPan:)];
		self.panGestureRecognizer.delegate = self;
		[self.chatroomCardsViewController.view addGestureRecognizer:self.panGestureRecognizer];

		// calculate open position for cards view
		CARDS_VIEW_CLOSED_Y = [UIScreen mainScreen].bounds.size.height - 120.0;
	}
	
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	
	self.introComplete = NO;	// TODO: read from NSUserDefaults
	self.cardsViewOpen = NO;
	
	[self refreshNearbyChatrooms];
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	/*
	// navigation bar setup
	self.title = @"Nearby Chats";
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsTapped:)];
	rightButton.tintColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
	self.navigationItem.rightBarButtonItem = rightButton;
	*/
	
	
	// display the intro only if the user has not already enabled location services for the app.
	// NOTE: should be checking NSUserDefaults (for introComplete) to see if user has gone through intro,
	//		 as that's more explicit than checking for location services enabled.
	// TODO: this should happen somewhere other than viewDidAppear,
	//		 since it's called when navigating back from chatroom.
	if (![[LocationManager instance] locationServicesEnabled]) {
		[self performSelector:@selector(presentIntro) withObject:nil afterDelay:0];
	} else {
		[[LocationManager instance] enableLocationServicesWithResult:nil];
		[self.chatroomMapViewController showUserLocation];
		[self openChatroomMapViewAnimated:NO];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)refreshNearbyChatrooms {
	[[ChatRoomApi instance] fetchChatroomsNearUserLocationWithSuccess:^(NSMutableArray *chatrooms) {
		self.chatroomMapViewController.chatroomModels = chatrooms;
		self.chatroomCardsViewController.chatroomModels = chatrooms;
	}];
}

- (void)presentIntro {
	if (self.introComplete) { return; }
	[self.navigationController presentViewController:self.introViewController animated:YES completion:nil];
}

- (void)settingsTapped:(id)sender {
	[self.navigationController pushViewController:self.mainSettingsViewController animated:YES];
}

- (void)didDismissModalViewController:(UIViewController *)viewController {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	
	if (viewController == self.introViewController) {
		self.introComplete = YES;
		[self.chatroomMapViewController showUserLocation];
	}
}


#pragma mark - ChatroomSelectorDelegate implementation
- (void)chatroomSelector:(id)chatroomSelector didHighlightChatroom:(Chatroom *)chatroom {

	if (chatroomSelector == self.chatroomCardsViewController) {
		[self.chatroomMapViewController highlightChatroom:chatroom];
	} else if (chatroomSelector == self.chatroomMapViewController) {
		[self.chatroomCardsViewController highlightChatroom:chatroom];
	}
	
}

- (void)chatroomSelector:(id)chatroomSelector didSelectChatroom:(Chatroom *)chatroom {
	if (chatroom == self.chatroomCardsViewController.stagedChatroom) {
		[self setCardsViewOpen:YES toPosition:[NSNumber numberWithDouble:CARDS_VIEW_OPEN_FULL_Y]];
		return;
	}
	
	[self enterChatroom:chatroom];
}

- (void)chatroomSelector:(id)chatroomSelector didStageNewChatroom:(Chatroom *)chatroom {
	self.chatroomMapViewController.stagedChatroom = chatroom;
	self.chatroomCardsViewController.stagedChatroom = chatroom;
}

- (void)chatroomSelectorDidAbortNewChatroom:(id)chatroomSelector {
	self.chatroomMapViewController.stagedChatroom = nil;
	self.chatroomCardsViewController.stagedChatroom = nil;
}

- (void)chatroomSelectorDidConfirmNewChatroom:(id)chatroomSelector {
	[self setCardsViewOpen:NO toPosition:[NSNumber numberWithFloat:CARDS_VIEW_CLOSED_Y]];
	[self enterChatroom:self.chatroomCardsViewController.stagedChatroom];
}

- (void)chatroomSelectorDidCancelNewChatroom:(id)chatroomSelector {
	[self setCardsViewOpen:NO toPosition:[NSNumber numberWithFloat:CARDS_VIEW_CLOSED_Y]];
}


#pragma mark - Chatroom view controller management
- (void)enterChatroom:(Chatroom *)chatroom {
	if (!chatroom) { return; }
	
	// TODO: LoginViewController if not authed, else straight to ChatroomViewController

    NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    // TODO try to fetch an existing user and skip the login page if necessary
    
//    [[UserApi fetchUserForUuid:(NSString *)uuid withSuccess:^(User *user){
//        
//        if (user!=nil){
//            ChatroomViewController *chatroomViewController = [[ChatroomViewController alloc] initWithChatroom:self.chatroom userName:self.screenNameTextField.text avatarImage:self.avatarImage.image];
//            [self.navigationController pushViewController:chatroomViewController animated:YES];
//        } else {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.chatroom = chatroom;
            [self.navigationController pushViewController:loginViewController animated:YES];
            self.navigationController.navigationBar.hidden = NO;
//        }
//        
//    }]];
    
}

- (void)openChatroomMapViewAnimated:(BOOL)animated {
	CGRect viewFrame = self.chatroomCardsViewController.view.frame;
	viewFrame.origin.y = CARDS_VIEW_CLOSED_Y;
	
	NSTimeInterval animateDuration = animated ? CARDS_VIEW_ANIMATE_CLOSE_DURATION : 0.0;
	CGFloat damping = 0.5;
	CGFloat initialSpringVelocity = 100.0;
	
	[UIView animateWithDuration:animateDuration delay:0 usingSpringWithDamping:damping initialSpringVelocity:initialSpringVelocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.chatroomCardsViewController.view.frame = viewFrame;
	} completion:nil];
}

- (void)onCardsViewPan:(UIPanGestureRecognizer *)panGestureRecognizer {
	switch (panGestureRecognizer.state) {
		case UIGestureRecognizerStateChanged:
			[self onCardsViewPanChanged:panGestureRecognizer];
			break;
		case UIGestureRecognizerStateEnded:
			[self onCardsViewPanEnded:panGestureRecognizer];
			break;
		case UIGestureRecognizerStatePossible:
		case UIGestureRecognizerStateBegan:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
			break;
	}
}

- (void)onCardsViewPanChanged:(UIPanGestureRecognizer *)panGestureRecognizer {
	// HACK: checking if stagedChatroom exists to perform new chat math.
	double cardsOpenY = self.chatroomCardsViewController.stagedChatroom ? CARDS_VIEW_OPEN_FULL_Y : CARDS_VIEW_OPEN_Y;
	
	CGPoint translation = [panGestureRecognizer translationInView:self.view];
	double targetY = (self.cardsViewOpen ? cardsOpenY : CARDS_VIEW_CLOSED_Y) + translation.y;
	CGRect frame = self.chatroomCardsViewController.view.frame;
	frame.origin.y = MAX(MIN(CARDS_VIEW_CLOSED_Y, targetY), cardsOpenY);
	self.chatroomCardsViewController.view.frame = frame;
}

- (void)onCardsViewPanEnded:(UIPanGestureRecognizer *)panGestureRecognizer {
	// HACK: checking if stagedChatroom exists to perform new chat math.
	double cardsOpenY = self.chatroomCardsViewController.stagedChatroom ? CARDS_VIEW_OPEN_FULL_Y : CARDS_VIEW_OPEN_Y;
	double cardsOpenThreshold = self.chatroomCardsViewController.stagedChatroom ? 0.75 : 0.65;
	
	double cardsViewPosition = (self.chatroomCardsViewController.view.frame.origin.y - cardsOpenY) / (CARDS_VIEW_CLOSED_Y - cardsOpenY);
	CGPoint panVelocity = [panGestureRecognizer velocityInView:self.view];
	
	if (!self.cardsViewOpen && cardsViewPosition < cardsOpenThreshold) {
		[self setCardsViewOpen:YES withVelocity:panVelocity toPosition:cardsOpenY];
	} else if (self.cardsViewOpen && cardsViewPosition > 0.35) {
		[self setCardsViewOpen:NO withVelocity:panVelocity toPosition:CARDS_VIEW_CLOSED_Y];
	} else {
		double position = (self.cardsViewOpen ? cardsOpenY : CARDS_VIEW_CLOSED_Y);
		[self setCardsViewOpen:self.cardsViewOpen withVelocity:panVelocity toPosition:position];
	}
}

- (void)setCardsViewOpen:(BOOL)cardsViewOpen toPosition:(NSNumber *)position {
	double positionDouble;
	if (position != nil) {
		positionDouble = [position doubleValue];
	} else {
		positionDouble = (self.cardsViewOpen ? CARDS_VIEW_OPEN_Y : CARDS_VIEW_CLOSED_Y);
	}
	
	[self setCardsViewOpen:cardsViewOpen withVelocity:CGPointMake(0, cardsViewOpen ? 100 : -100) toPosition:positionDouble];
}

- (void)setCardsViewOpen:(BOOL)cardsViewOpen withVelocity:(CGPoint)velocity toPosition:(double)position {
	_cardsViewOpen = cardsViewOpen;
	
	CGRect frame = self.chatroomCardsViewController.view.frame;
	double remainingDistance;
	CGFloat damping = cardsViewOpen ? 0.75f : 1.0f;	// don't bounce when closing, as this reveals stuff below bottom edge
	
	if (cardsViewOpen) {
		remainingDistance = position - frame.origin.y;
		frame.origin.y = position;
	} else {
		remainingDistance = position - frame.origin.y;
		frame.origin.y = position;
	}
	
	double initialSpringVelocity = remainingDistance / velocity.y;
	[UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:damping initialSpringVelocity:initialSpringVelocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.chatroomCardsViewController.view.frame = frame;
	} completion:nil];
}

@end
