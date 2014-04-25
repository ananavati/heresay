//
//  ChatroomCardViewCell.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomCardViewCell.h"

@interface ChatroomCardViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameInputTitle;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UILabel *topicInputTitle;
@property (weak, nonatomic) IBOutlet UITextField *topicInput;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (weak, nonatomic) Chatroom* chatRoom;
@end



@implementation ChatroomCardViewCell

- (void)awakeFromNib
{
    // Initialization code
	self.nameLabel.font = [UIFont fontWithName:@"OpenSans" size:17];
	self.nameInputTitle.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
	self.nameInput.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
	self.topicInputTitle.font = [UIFont fontWithName:@"OpenSans-Light" size:17];
	self.topicInput.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
	self.submitButton.titleLabel.font = [UIFont fontWithName:@"Overlock-Regular" size:30];
	self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Overlock-Regular" size:14];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithModel:(Chatroom *)model {
	if(!self.isNewChatroom) {
        self.nameLabel.text = model.chatRoomName;
        self.chatRoom = model;
    }
}

- (CGSize)calcSizeWithModel:(Chatroom *)model {
	
	CGSize size = CGSizeMake(320, 360);
	return size;
	
}

- (void)setIsNewChatroom:(BOOL)isNewChatroom {
	_isNewChatroom = isNewChatroom;
	
	self.nameInputTitle.hidden =
	self.nameInput.hidden =
	self.topicInputTitle.hidden =
	self.topicInput.hidden =
	self.submitButton.hidden =
	self.cancelButton.hidden =
	!self.isNewChatroom;
	
	self.nameLabel.hidden = self.isNewChatroom;
}

- (IBAction)nameInputChanged:(id)sender {
	// TODO: hide/show submit button when there's content here and topicInput
}

- (IBAction)topicInputChanged:(id)sender {
	// TODO: hide/show submit button when there's content here and nameInput
}

- (IBAction)submitButtonTapped:(id)sender {
    self.chatRoom.chatRoomName = self.nameInput.text;
    self.chatRoom.placeName = self.topicInput.text;
    self.chatRoom.latitude = [NSNumber numberWithDouble:self.chatRoom.geolocation.latitude];
    self.chatRoom.longitude = [NSNumber numberWithDouble: self.chatRoom.geolocation.longitude];
    
	[self.delegate chatroomCardViewDidConfirm:self];
}

- (IBAction)cancelButtonTapped:(id)sender {
	[self.delegate chatroomCardViewDidCancel:self];
}

@end
