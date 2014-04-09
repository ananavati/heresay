//
//  Chatroom.h
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface Chatroom : NSObject

// TODO: PFObject has this property already;
// we should remove it when we turns models into PFObects.
@property (strong, nonatomic) NSString *objectId;

@property (strong, nonatomic) NSString *name;

// TODO: PFObject has this property already;
// we should remove it when we turns models into PFObects.
@property (strong, nonatomic) NSString *createdAt;

@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) NSString *creationDatestamp;


#pragma mark - Location-related properties
@property (strong, nonatomic) NSNumber *radius;
@property (strong, nonatomic) NSString *placeName;

// TODO: Will need to convert to PFGeoPoint for de/serialization.
@property (strong, nonatomic) CLLocation *location;


#pragma mark - User-related properties
// TODO: We'll probably use PFRelation to handle many-to-many relationships.
// http://blog.parse.com/2012/05/17/new-many-to-many/
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableArray *admins;
@property (strong, nonatomic) NSMutableArray *activeUsers;
@property (strong, nonatomic) NSMutableArray *nearbyUsers;

@end
