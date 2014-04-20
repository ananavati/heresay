//
//  ChatroomCardViewCell.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chatroom.h"

@interface ChatroomCardViewCell : UICollectionViewCell

- (void)initWithModel:(Chatroom *)model;
- (CGSize)calcSizeWithModel:(Chatroom *)model;

@end
