//
//  Chatroom.h
//  Heresay
//
//  Created by Thomas Ezan on 4/3/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <Parse/PFObject+Subclass.h>
#import <Parse/Parse.h>

@interface Chatroom : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *chatRoomName;

#pragma mark - Location-related properties
@property (strong, nonatomic) NSNumber *radius;
@property (strong, nonatomic) NSString *placeName;

// TODO: Will need to convert to PFGeoPoint for de/serialization.
@property (strong, nonatomic) PFGeoPoint *geolocation;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;


#pragma mark - User-related properties
// TODO: We'll probably use PFRelation to handle many-to-many relationships.
// http://blog.parse.com/2012/05/17/new-many-to-many/
//@property (strong, nonatomic) NSMutableArray *users;
//@property (strong, nonatomic) NSMutableArray *admins;
//@property (strong, nonatomic) NSMutableArray *activeUsers;
//@property (strong, nonatomic) NSMutableArray *nearbyUsers;

+ (Chatroom *)initWithJSON:(Chatroom *)json;

@end
