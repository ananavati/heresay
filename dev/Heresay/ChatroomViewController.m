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
#import "MessageApi.h"
#import "Chatroom.h"
#import "UIColor+HeresayColor.h"


@interface ChatroomViewController ()

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSMutableArray *messageList;
@property (strong, nonatomic) NSString *chatroomName;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) Chatroom *chartroom;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) NSTimer *nsTimer;


@end

@implementation ChatroomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id)initWithChatroom:(Chatroom *)chatroom userName:(NSString *)userName avatarImage:(UIImage*)image{
    self.chartroom = chatroom;
    self.chatroomName = chatroom.chatRoomName;
    self.userName = userName;
    self.avatarImage = image;
    
    [self initialize];
    return self;
}

- (void) initialize{
  [self fetchMessages];
    
  self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(fetchMessages)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    // Set the status bar style white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    // Init message list array
    self.messageList = [[NSMutableArray alloc] init];
    
    // Init tableview
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    
    //Init JSBubbleView UI
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.title = self.chatroomName;
    self.messageInputView.textView.placeHolder = @"Message";
    self.sender = self.userName;
    
    
    //
    self.navigationController.navigationBar.tintColor = [UIColor blueHighlightColor];
  
}


//-(void)downloadImages{
//    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
//    PFUser *user = [PFUser currentUser];
//    [query whereKey:@"user" equalTo:user];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        // If there are photos, we start extracting the data
//        // Save a list of object IDs while extracting this data
//        
//       self.newObjectIDArray = [NSMutableArray array];
//        
//        if (objects.count > 0) {
//            for (PFObject *eachObject in objects) {
//                [self.newObjectIDArray addObject:[eachObject objectId]];
//            }
//        }
//    }];
//}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.nsTimer invalidate];
    self.nsTimer = nil;
    
    
    // Set the status bar style black
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}




#pragma mark - messages api

- (void)fetchMessages {
    [[MessageApi instance] fetchMessagesForChatroomWithId:self.chartroom.objectId withSuccess:^(NSArray *messages) {
        
        NSLog(@"messages: %@", messages);
        
        [self.messageList removeAllObjects];
        
        [self.messageList addObjectsFromArray:messages];
        [self.tableView reloadData];
        
        [self scrollToBottomAnimated:YES];
    }];
}


#pragma - JSMessagesViewDelegate
/**
 *  Tells the delegate that the user has sent a message with the specified text, sender, and date.
 *
 *  @param text   The text that was present in the textView of the messageInputView when the send button was pressed.
 *  @param sender The user who sent the message.
 *  @param date   The date and time at which the message was sent.
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date{
    
    Message *message = [[Message alloc] initWithMessageText:text authorId:sender uuid:[[[UIDevice currentDevice] identifierForVendor] UUIDString] chatRoom:self.chartroom.objectId];
    
    [[MessageApi instance] saveMessage:message];
    
    [self.messageList addObject:message];
    [self.tableView reloadData];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
    
}

/**
 *  Asks the delegate for the message type for the row at the specified index path.
 *
 *  @param indexPath The index path of the row to be displayed.
 *
 *  @return A constant describing the message type.
 *  @see JSBubbleMessageType.
 */
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    Message *currMessage = self.messageList[indexPath.row];
    
    if (currMessage.sentFromCurrentUser) {
        return JSBubbleMessageTypeOutgoing;
    } else {
        return JSBubbleMessageTypeIncoming;
    }

    
    return (JSBubbleMessageType)self.messageList[indexPath.row];
}

/**
 *  Asks the delegate for the bubble image view for the row at the specified index path with the specified type.
 *
 *  @param type      The type of message for the row located at indexPath.
 *  @param indexPath The index path of the row to be displayed.
 *
 *  @return A `UIImageView` with both `image` and `highlightedImage` properties set.
 *  @see JSBubbleImageViewFactory.
 */
- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (type==JSBubbleMessageTypeOutgoing) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:JSBubbleMessageTypeOutgoing
                                                          color:[UIColor blueHighlightColor]];
    } else {
        return [JSBubbleImageViewFactory bubbleImageViewForType:JSBubbleMessageTypeIncoming
                                                          color:[UIColor lightGrayColor]];
    
    }
    

}

/**
 *  Asks the delegate for the input view style.
 *
 *  @return A constant describing the input view style.
 *  @see JSMessageInputViewStyle.
 */
- (JSMessageInputViewStyle)inputViewStyle{
    return JSMessageInputViewStyleFlat;
}


#pragma - JSMessagesViewDataSource
/**
 *  Asks the data soruce for the message object to display for the row at the specified index path. The message text is displayed in the bubble at index path. The message date is displayed *above* the row at the specified index path. The message sender is displayed *below* the row at the specified index path.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return An object that conforms to the `JSMessageData` protocol containing the message data. This value must not be `nil`.
 */
- (id<JSMessageData>)messageForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (JSMessage *)self.messageList[indexPath.row];
}

/**
 *  Asks the data source for the imageView to display for the row at the specified index path with the given sender. The imageView must have its `image` property set.
 *
 *  @param indexPath An index path locating a row in the table view.
 *  @param sender    The name of the user who sent the message at indexPath.
 *
 *  @return An image view specifying the avatar for the message at indexPath. This value may be `nil`.
 */
- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender{
    
    UIImage *avatar;
    Message *currMessage = self.messageList[indexPath.row];
    
    if (currMessage.sentFromCurrentUser && self.avatarImage!=nil) {
        avatar = [JSAvatarImageFactory avatarImage:self.avatarImage croppedToCircle:YES];
        
    } else {
            avatar = [JSAvatarImageFactory avatarImageNamed:@"avatar" croppedToCircle:YES];
    }
    
    return [[UIImageView alloc] initWithImage:avatar];
}


//
//  *** Implement to customize cell further
//
- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
        
//        if ([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)]) {
//            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
//            [attrs setValue:[UIColor blueColor] forKey:UITextAttributeTextColor];
//            
//            cell.bubbleView.textView.linkTextAttributes = attrs;
//        }
//    }
    
//    if (cell.timestampLabel) {
//        cell.timestampLabel.textColor = [UIColor lightGrayColor];
//        cell.timestampLabel.shadowOffset = CGSizeZero;
//    }
//    if (cell.subtitleLabel) {
//        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
//    }
    
//#if TARGET_IPHONE_SIMULATOR
//    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeNone;
//#else
//    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeAll;
//#endif
}


#pragma - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.messageList.count;
    
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling{
    return YES;
}

- (BOOL)allowsPanToDismissKeyboard{
    return YES;
}

@end
