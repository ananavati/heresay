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


@interface ChatroomViewController ()

@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSMutableArray *messageList;
@property (strong, nonatomic) NSString *chatroomName;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) Chatroom *chartroom;

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

-(id)initWithChatroom:(Chatroom *)chatroom userName:(NSString *)userName{
    self.chartroom = chatroom;
    self.chatroomName = chatroom.chatRoomName;
    self.userName = userName;
    
    [self initialize];
    return self;
}

- (void) initialize
{
    // TODO: get this chat room id from the current view
    NSString* chatRoomId = @"BTY9Cggc6r";
    [self fetchMessages:chatRoomId];
    
    NSLog(@"Chatroom name %@ ", self.chartroom.objectId);
    
//    [self fetchMessages:self.chartroom.objectId];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init message list array
    self.messageList = [[NSMutableArray alloc] init];
    
    // Init tableview
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    
    //Init JSBubbleView UI
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    self.title = self.chatroomName;
    self.messageInputView.textView.placeHolder = @"Message";
    self.sender = self.userName;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - messages api

- (void)fetchMessages:(NSString*)chatRoomId {
    [[MessageApi instance] fetchMessagesForChatroomWithId:chatRoomId withSuccess:^(NSArray *messages) {
        
        NSLog(@"messages:%@" , messages);
        
        [self.messageList addObjectsFromArray:messages];
        [self.tableView reloadData];
        
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
    
    NSLog(@"didSendText: %@", text);
    
    Message *message = [[Message alloc] initWithMessageText:text authorId:sender];

    // TODO Thomas: send message to Parse
    
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
    
    if ([currMessage.authorId isEqualToString:self.userName]) {
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
                                                          color:[UIColor js_bubbleLightGrayColor]];
    } else {
        return [JSBubbleImageViewFactory bubbleImageViewForType:JSBubbleMessageTypeIncoming
                                                          color:[UIColor js_bubbleBlueColor]];
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
    return nil;
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

//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    // Get cell
//    MessageViewCell *cell = [self.messageTableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
//    
//    // Get current message
//    Message *currMessage = self.messageList[indexPath.row];
//    
//    // Populate current Cell
//    cell.userLabel.text = currMessage.authorId;
//    cell.messageLabel.text = currMessage.text;
//    
//    return cell;
//    
//}

@end
