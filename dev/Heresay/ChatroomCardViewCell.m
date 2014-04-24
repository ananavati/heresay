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
	/*
    // Initialization code
	self.titleLabel.font = [UIFont fontWithName:@"Aller-Bold" size:20];
	self.synopsisLabel.font = [UIFont fontWithName:@"Aller-Light" size:13];
	self.castLabel.font = [UIFont fontWithName:@"Aller-LightItalic" size:13];
	 */
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
