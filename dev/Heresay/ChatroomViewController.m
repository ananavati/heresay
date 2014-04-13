//
//  ChatroomViewController.m
//  Heresay
//
//  Created by Thomas Ezan on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomViewController.h"
#import "MessageViewCell.h"
#import "Message.h"
#import "DummyDataProvider.h"

@interface ChatroomViewController ()

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSArray *messageList;

@end

@implementation ChatroomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init tableview
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    
    
    // Init custom UITableCellView
    UINib *nib = [UINib nibWithNibName:@"MessageViewCell" bundle:nil];
    [self.messageTableView registerNib:nib forCellReuseIdentifier:@"MessageCell"];
    
    // Init data
    // TODO pass the chatroom Id
    [[DummyDataProvider instance] fetchMessagesForChatroomWithId:@"toto" withSuccess:^(NSArray *messages) {
		self.messageList = messages;
        NSLog(@"messages:%@", messages.description);
		[self.messageTableView reloadData];
	}];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.messageList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Get cell
    MessageViewCell *cell = [self.messageTableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    
    // Get current message
    Message *currMessage = self.messageList[indexPath.row];
    
    // Populate current Cell
    cell.userLabel.text = currMessage.authorId;
    cell.messageLabel.text = currMessage.text;
    
    return cell;
    
}

@end
