//
//  ChatroomCardsViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/19/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "CSAnimationView.h"

#import "ChatroomCardsViewController.h"
#import "ChatRoomApi.h"
#import "Chatroom.h"

@interface ChatroomCardsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

@end


static double CARD_HEIGHT;

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

        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.opaque = YES;
        
        [self.collectionView startCanvasAnimation];
		
		CARD_HEIGHT = [UIScreen mainScreen].bounds.size.height - 20*2;
	}

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
	// TODO: no idea why collectionView doesn't layout unless panGestureRecognizer is set up!
}

- (void)setChatroomModels:(NSMutableArray *)chatroomModels {
	_chatroomModels = chatroomModels;
	[self.collectionView reloadData];
}

- (void)setStagedChatroom:(Chatroom *)stagedChatroom {
	BOOL addedOrRemovedStagedChatroom = (!_stagedChatroom && stagedChatroom) || (_stagedChatroom && !stagedChatroom);
	_stagedChatroom = stagedChatroom;
	
	if (addedOrRemovedStagedChatroom) {
		if (self.stagedChatroom) {
			// staged new chatroom
			[self.collectionView insertSections:[[NSIndexSet alloc] initWithIndex:1]];
			[self highlightChatroom:self.stagedChatroom];
		} else {
			// unstaged new chatroom
			[self.collectionView deleteSections:[[NSIndexSet alloc] initWithIndex:1]];
		}
	} else {
		if (self.stagedChatroom) {
			// updated new chatroom
			[self.collectionView reloadData];
			[self highlightChatroom:self.stagedChatroom];
		}
	}
}

- (void)highlightChatroom:(Chatroom *)chatroom {
	int chatroomRow = (int)[self.chatroomModels indexOfObject:chatroom];
	int chatroomSection;
	if ([self.chatroomModels indexOfObject:chatroom] != NSNotFound) {
		// one of existing chatrooms
		chatroomSection = 0;
	} else {
		if (self.stagedChatroom && (chatroom == self.stagedChatroom)) {
			// staged chatroom
			chatroomRow = 0;
			chatroomSection = 1;
		} else {
			// chatroom not found
			return;
		}
	}
	
	[self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:chatroomRow inSection:chatroomSection] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}



#pragma mark - ChatroomCardViewDelegate implementation
- (void)chatroomCardViewDidConfirm:(ChatroomCardViewCell *)chatroomCardView {
	[self.delegate chatroomSelectorDidConfirmNewChatroom:self];
}

- (void)chatroomCardViewDidCancel:(ChatroomCardViewCell *)chatroomCardView {
	[self.delegate chatroomSelectorDidCancelNewChatroom:self];
}



#pragma mark - UICollectionView methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (section == 0) {
		return self.chatroomModels ? [self.chatroomModels count] : 0;
	} else {
		return self.stagedChatroom ? 1 : 0;
	}
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return self.stagedChatroom ? 2 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ChatroomCardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatroomCardViewCell" forIndexPath:indexPath];
	if (!self.stagedChatroom && (!self.chatroomModels || [self.chatroomModels count] == 0)) { return cell; }
	
	if (indexPath.section == 0) {
		// existing chat card
		[cell initWithModel:self.chatroomModels[indexPath.row]];
		cell.isNewChatroom = false;
	} else {
		// new chat card
		[cell initWithModel:self.stagedChatroom];
		cell.delegate = self;
		cell.isNewChatroom = true;
	}
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		[self.delegate chatroomSelector:self didSelectChatroom:self.chatroomModels[indexPath.row]];
	} else {
		[self.delegate chatroomSelector:self didSelectChatroom:self.stagedChatroom];
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(280, CARD_HEIGHT);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	// specify edge insets (margins) around each collection view cell
	return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = self.collectionView.frame.size.width;
	int pageNum = self.collectionView.contentOffset.x / pageWidth;
	if (pageNum < 0 || pageNum > self.chatroomModels.count) { return; }
	
	if (pageNum > self.chatroomModels.count - 1 && self.stagedChatroom) {
		[self.delegate chatroomSelector:self didHighlightChatroom:self.stagedChatroom];
	} else {
		[self.delegate chatroomSelector:self didHighlightChatroom:self.chatroomModels[pageNum]];
	}
}

@end
