//
//  User.h
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// TODO: PFObject has this property already;
// we should remove it when we turns models into PFObects.
@property (strong, nonatomic) NSString *objectId;

@property (strong, nonatomic) NSString *name;

// TODO: PFObject has this property already;
// we should remove it when we turns models into PFObects.
@property (strong, nonatomic) NSString *createdAt;

@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSString *creationDatestamp;


@property (strong, nonatomic) NSString *profileImageURL;


@end
