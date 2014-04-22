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
#import "MainSettingsViewController.h"
#import "LoginViewController.h"
#import "LocationManager.h"
#import "ChatRoomApi.h"


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
static const double CARDS_VIEW_OPEN_Y = 0.0;
static const double CARDS_VIEW_ANIMATE_CLOSE_DURATION = 0.75;

@implementation ChatroomContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

	if (self) {
		
		// set up chatroom view controllers
		self.chatroomMapViewController = [[ChatroomMapViewController alloc] init];
		self.chatroomMapViewController.delegate = self;
//		self.chatroomMapViewController.title = @"Map";
//		self.chatroomMapViewController.modalTransitionStyle = UIModalPresentationCustom;
//		self.chatroomMapViewController.transitioningDelegate = self;
		[self.view addSubview:self.chatroomMapViewController.view];
		
		self.chatroomCardsViewController = [[ChatroomCardsViewController alloc] init];
		self.chatroomCardsViewController.delegate = self;
//		self.chatroomCardsViewController.title = @"List";
//		self.chatroomCardsViewController.modalTransitionStyle = UIModalPresentationCustom;
//		self.chatroomCardsViewController.transitioningDelegate = self;
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
		CARDS_VIEW_CLOSED_Y = -self.chatroomCardsViewController.view.frame.size.height + 100.0;
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

	// TODO: LoginViewController if not authed, else straight to ChatroomViewController
	LoginViewController *loginViewController = [[LoginViewController alloc] init];
	loginViewController.chatroom = chatroom;
	
	[self.navigationController pushViewController:loginViewController animated:YES];
	self.navigationController.navigationBar.hidden = NO;
	
}

- (void)chatroomSelector:(id)chatroomSelector didStageNewChatroom:(Chatroom *)chatroom {

	self.chatroomMapViewController.stagedChatroom = chatroom;
	self.chatroomCardsViewController.stagedChatroom = chatroom;
	
}

- (void)chatroomSelectorDidAbortNewChatroom:(id)chatroomSelector {
	
	self.chatroomMapViewController.stagedChatroom = nil;
	self.chatroomCardsViewController.stagedChatroom = nil;
	
}


#pragma mark - Chatroom view controller management

- (void)openChatroomMapViewAnimated:(BOOL)animated {
	
	CGRect viewFrame = self.chatroomCardsViewController.view.frame;
//	viewFrame.origin.y = -[UIScreen mainScreen].bounds.size.height + CARDS_VIEW_CLOSED_Y;
	viewFrame.origin.y = CARDS_VIEW_CLOSED_Y;
	
	NSTimeInterval animateDuration = animated ? CARDS_VIEW_ANIMATE_CLOSE_DURATION : 0.0;
	CGFloat damping = 0.5;
	CGFloat initialSpringVelocity = 100.0;
	
	[UIView animateWithDuration:animateDuration delay:0 usingSpringWithDamping:damping initialSpringVelocity:initialSpringVelocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.chatroomCardsViewController.view.frame = viewFrame;
	} completion:nil];
	
}

- (void)openChatroomCardsViewAnimated:(BOOL)animated {
	
	
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
	CGPoint translation = [panGestureRecognizer translationInView:self.view];
	double targetY = (self.cardsViewOpen ? CARDS_VIEW_OPEN_Y : CARDS_VIEW_CLOSED_Y) + translation.y;
	CGRect frame = self.chatroomCardsViewController.view.frame;
	frame.origin.y = MIN(MAX(CARDS_VIEW_CLOSED_Y, targetY), CARDS_VIEW_OPEN_Y);
	self.chatroomCardsViewController.view.frame = frame;
}

- (void)onCardsViewPanEnded:(UIPanGestureRecognizer *)panGestureRecognizer {
	double cardsViewPosition = self.chatroomCardsViewController.view.frame.origin.y / (CARDS_VIEW_CLOSED_Y - CARDS_VIEW_OPEN_Y);
	CGPoint panVelocity = [panGestureRecognizer velocityInView:self.view];
	
	if (!self.cardsViewOpen && cardsViewPosition < 0.65) {
		[self setCardsViewOpen:YES withVelocity:panVelocity];
	} else if (self.cardsViewOpen && cardsViewPosition > 0.35) {
		[self setCardsViewOpen:NO withVelocity:panVelocity];
	} else {
		[self setCardsViewOpen:self.cardsViewOpen withVelocity:panVelocity];
	}
}

- (void)setCardsViewOpen:(BOOL)cardsViewOpen {
	[self setCardsViewOpen:cardsViewOpen withVelocity:CGPointMake(0, cardsViewOpen ? 100 : -100)];
}

- (void)setCardsViewOpen:(BOOL)cardsViewOpen withVelocity:(CGPoint)velocity {
	_cardsViewOpen = cardsViewOpen;
	
	CGRect frame = self.chatroomCardsViewController.view.frame;
	double remainingDistance;
	CGFloat damping = cardsViewOpen ? 1.0f : 0.75f;	// don't bounce when opening, as this reveals stuff below top edge
	
	if (cardsViewOpen) {
		remainingDistance = CARDS_VIEW_OPEN_Y - frame.origin.y;
		frame.origin.y = CARDS_VIEW_OPEN_Y;
	} else {
		remainingDistance = CARDS_VIEW_CLOSED_Y - frame.origin.y;
		frame.origin.y = CARDS_VIEW_CLOSED_Y;
	}
	
	double initialSpringVelocity = remainingDistance / velocity.y;
	[UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:damping initialSpringVelocity:initialSpringVelocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.chatroomCardsViewController.view.frame = frame;
	} completion:nil];
}

@end
