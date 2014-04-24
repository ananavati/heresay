//
//  LoginViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/11/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "ChatroomViewController.h"
#import "User.h"
#import "UserApi.h"
#import "ChatRoomApi.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *chatroomNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *screenNameTextField;
@property (assign, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;


@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
	if (self.chatroom) {
		self.chatroomNameLabel.text = self.chatroom.chatRoomName;
	} else {
		self.chatroomNameLabel.text = @"New Chatroom";
	}
    
    self.avatarImage.image = [JSAvatarImageFactory avatarImageNamed:@"avatar" croppedToCircle:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)startChatroom:(id)sender {    
    [self.screenNameTextField endEditing:YES];
    
    // save the chat room on parse
    PFObject* c = [[ChatRoomApi instance] saveChatRoom:self.chatroom];
    
    [c saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFQuery *query = [PFQuery queryWithClassName:@"chat_rooms"];
            [query orderByDescending:@"createdAt"];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                self.chatroom = [Chatroom initWithJSON:objects[0]];
                NSLog(@"Start chatroom with %@", [self.chatroom description]);
                
                [self createUserWithName:self.screenNameTextField.text avatar:self.avatarImage.image];
                
                ChatroomViewController *chatroomViewController = [[ChatroomViewController alloc] initWithChatroom:self.chatroom userName:self.screenNameTextField.text avatarImage:self.avatarImage.image];
                [self.navigationController pushViewController:chatroomViewController animated:YES];
            }];
        }
    }];
}

- (IBAction)didTouchTakeAPicture:(id)sender {
    UIImagePickerController *picker;
    picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    

    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)didTouchPickAPicture:(id)sender {
    UIImagePickerController *picker;
    picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)createUserWithName:(NSString *)userName avatar:(UIImage*)image{
    
    User *newUser = [[User alloc] init];
    newUser.name = userName;
    
    newUser.profileImageURL = @"";
    newUser.avatarImage = image;
    
    
    // TODO send the UIImage on the internet somewhere to store it and let's
    // persit the URL of the image
    newUser.uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    [[UserApi instance] saveUser:newUser];
    
}



#pragma - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.avatarImage.image = [JSAvatarImageFactory avatarImage:chosenImage croppedToCircle:YES];
 
}


@end
