//
//  ChatroomListViewController.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomListViewController.h"
#import "LocationManager.h"
#import "NewChatroomViewCell.h"
#import "ChatroomViewCell.h"

#import "ChatRoomApi.h"

@interface ChatroomListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *chatroomModels;

@end

@implementation ChatroomListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void) initialize {
    self.chatroomModels = [[NSMutableArray alloc] init];
    
    // this method should never be called from viewDidLoad
    // viewDidLoad method could be called from different places multiple times
    // TODO:arpan fetch more rooms pull down to refresh behavior needs to be added
    [self fetchChatRooms];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    // UITableView setup
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.separatorInset = UIEdgeInsetsZero;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	// Register cell nibs
	UINib *cellNib = [UINib nibWithNibName:@"NewChatroomViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"NewChatroomViewCell"];
	
    cellNib = [UINib nibWithNibName:@"ChatroomViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"ChatroomViewCell"];
}

- (void)viewDidAppear:(BOOL)animated {
	//
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - parse backend api calls

- (void)fetchChatRooms {
    [[ChatRoomApi instance] fetchChatroomsNearLocation:[[LocationManager instance] userLocation] withSuccess:^(NSArray *chatrooms) {
        self.chatroomModels = chatrooms;
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableView protocol implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
		case 1:
			return self.chatroomModels ? [self.chatroomModels count] : 0;
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		NewChatroomViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewChatroomViewCell" forIndexPath:indexPath];
		return cell;
	} else if (indexPath.section == 1) {
		ChatroomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatroomViewCell" forIndexPath:indexPath];
//		cell.delegate = self;
		if (self.chatroomModels && [self.chatroomModels count] > 0) {
			[cell initWithModel:[self.chatroomModels objectAtIndex:[indexPath row]]];
		}
		return cell;
	}
	
	return nil;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.chatroomModels || [self.chatroomModels count] == 0) { return 60; }
	return [[self cellForMetrics] calcHeightWithModel:self.chatroomModels[[indexPath row]]];
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithTweetModel:self.tweetModels[indexPath.row]];
	[self.navigationController pushViewController:tweetDetailViewController animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	*/
	
	switch (indexPath.section) {
		case 0:
			// Send nil to create new Chatroom
			[self.delegate didSelectChatroom:self withChatroom:nil];
			break;
		case 1:
			[self.delegate didSelectChatroom:self withChatroom:self.chatroomModels[indexPath.row]];
			break;
	}
	
}


@end
