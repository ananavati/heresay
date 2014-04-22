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

@end



@implementation ChatroomCardViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithModel:(Chatroom *)model {
	self.nameLabel.text = model.chatRoomName;
}

- (CGSize)calcSizeWithModel:(Chatroom *)model {
	
	CGSize size = CGSizeMake(220, 360);
	return size;
	
}

@end
