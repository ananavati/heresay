//
//  ChatroomCardsViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "ChatroomCardsViewController.h"
#import "ChatRoomApi.h"
#import "Chatroom.h"
#import "ChatroomCardViewCell.h"

@interface ChatroomCardsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

@end

@implementation ChatroomCardsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

	if (self) {
		// TODO: no idea why collectionView doesn't layout unless panGestureRecognizer is set up...
		UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
		[self.view addGestureRecognizer:panGestureRecognizer];
		
		self.collectionView.pagingEnabled = YES;
		self.collectionView.delegate = self;
		self.collectionView.dataSource = self;
		
		self.collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
		self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.collectionViewFlowLayout.minimumLineSpacing = 40;	// for horizontal scroll, this actually defines horizontal spacing
		self.collectionView.collectionViewLayout = self.collectionViewFlowLayout;
		
		UINib *cellNib = [UINib nibWithNibName:@"ChatroomCardViewCell" bundle:nil];
		[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ChatroomCardViewCell"];
	}

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setChatroomModels:(NSArray *)chatroomModels {
	_chatroomModels = chatroomModels;
	[self.collectionView reloadData];
}

- (void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
	// TODO: no idea why collectionView doesn't layout unless panGestureRecognizer is set up!
}


#pragma mark - UICollectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.chatroomModels ? [self.chatroomModels count] : 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ChatroomCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatroomCardViewCell" forIndexPath:indexPath];
	if (!self.chatroomModels || [self.chatroomModels count] == 0) { return cell; }
	
	[cell initWithModel:self.chatroomModels[indexPath.row]];
//	cell.delegate = self;
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Chatroom (card) selected:%@", self.chatroomModels[indexPath.row]);
	
//	[self.delegate didSelectChatroom:self withChatroom:nil];
	[self.delegate didSelectChatroom:self withChatroom:self.chatroomModels[indexPath.row]];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(280, 360);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	// specify edge insets (margins) around each collection view cell
	return UIEdgeInsetsMake(20, 20, 20, 20);
}

@end
