//
//  MainSettingsViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "MainSettingsViewController.h"


@interface MainSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *cellContents;

@end


@implementation MainSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		//
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// UITableView setup
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	/*
	 // Register cell nibs
	 UINib *cellNib = [UINib nibWithNibName:@"NewChatroomViewCell" bundle:nil];
	 [self.tableView registerNib:cellNib forCellReuseIdentifier:@"NewChatroomViewCell"];
	 cellNib = [UINib nibWithNibName:@"ChatroomViewCell" bundle:nil];
	 [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ChatroomViewCell"];
	 */
	
	self.cellContents = @[@"Setting One", @"Setting Two", @"Setting Three"];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark - UITableView protocol implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.cellContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
	cell.textLabel.text = self.cellContents[indexPath.row];
	return cell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.chatroomModels || [self.chatroomModels count] == 0) { return 60; }
	return [[self cellForMetrics] calcHeightWithModel:self.chatroomModels[[indexPath row]]];
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//
}


@end
