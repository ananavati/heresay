//
//  DummyDataProvider.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/12/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "DummyDataProvider.h"
#import "Chatroom.h"


@interface DummyDataProvider ()

@property (strong, nonatomic) NSDictionary *dummyData;
@property (strong, nonatomic) NSMutableArray *nearbyChatrooms;
@property (strong, nonatomic) User *authenticatedUser;
@property (strong, nonatomic) NSMutableArray *messagesForChatroom;

@end


@implementation DummyDataProvider

+ (DummyDataProvider *)instance {
	static DummyDataProvider *instance = nil;
	static dispatch_once_t pred;
	
	if (instance) return instance;
	
	dispatch_once(&pred, ^{
		instance = [DummyDataProvider alloc];
		instance = [instance init];
	});
	
	return instance;
}

- (DummyDataProvider *)init {
	self = [super init];
	[self initDummyData];
	return self;
}

- (User *)getAuthenticatedUser {
	return nil;
}

- (void)fetchChatroomsNearLocation:(CLLocation *)location withSuccess:(void (^)(NSArray *chatrooms))success {
	self.nearbyChatrooms = [[NSMutableArray alloc] init];
	for (NSDictionary *chatroomData in self.dummyData[@"nearbyChatrooms"]) {
		[self.nearbyChatrooms addObject:[Chatroom initWithJSON:chatroomData]];
	}
	
	// call success block after delay to simulate asynchronicity
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		success(self.nearbyChatrooms);
	});
}

- (void)fetchMessagesForChatroomWithId:(NSString *)chatroomId withSuccess:(void (^)(NSArray *messages))success {
	
    self.messagesForChatroom = [[NSMutableArray alloc] init];
    for (NSDictionary *messagesData in self.dummyData[@"messages"]){
        [self.messagesForChatroom addObject:[Message initWithJSON:messagesData]];
    }
    
    
    // call success block after delay to simulate asynchronicity
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		success(self.messagesForChatroom);
	});
}

- (void)initDummyData {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dummyData" ofType:@"json"];
	self.dummyData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:nil];
}

@end
