//
//  ChatroomViewCell.m
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomViewCell.h"

@interface ChatroomViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ChatroomViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithModel:(Chatroom *)chatroomModel {
	self.nameLabel.text = chatroomModel.name;
}

@end
