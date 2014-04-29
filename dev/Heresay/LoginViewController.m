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
#import "UIColor+HeresayColor.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *chatroomNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *screenNameTextField;
@property (assign, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *chooseScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *goLabel;
@property (weak, nonatomic) IBOutlet UIButton *takeAPictureLabel;
@property (weak, nonatomic) IBOutlet UIButton *pickAPictureLabel;


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
	
    // Set the status bar style white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.chooseScreenNameLabel.font = [UIFont fontWithName:@"Oxygen" size:17];
    self.goLabel.titleLabel.font = [UIFont fontWithName:@"Oxygen" size:17];
    self.takeAPictureLabel.titleLabel.font = [UIFont fontWithName:@"Oxygen" size:17];
    self.pickAPictureLabel.titleLabel.font = [UIFont fontWithName:@"Oxygen" size:17];
	self.screenNameTextField.font = [UIFont fontWithName:@"Oxygen" size:17];
    
    self.navigationController.navigationBar.tintColor = [UIColor blueHighlightColor];

    
}

- (void)viewWillAppear:(BOOL)animated {
	if (self.chatroom) {
		self.chatroomNameLabel.text = self.chatroom.chatRoomName;
	} else {
		self.chatroomNameLabel.text = @"New Chatroom";
	}
    
    self.avatarImage.image = [JSAvatarImageFactory avatarImageNamed:@"avatar" croppedToCircle:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated{
    // Set the status bar style black
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)startChatroom:(id)sender {    
    [self.screenNameTextField endEditing:YES];
    
    if (self.chatroom.objectId) {
        NSLog(@"Start chatroom with %@", [self.chatroom description]);
        
        [self createUserWithName:self.screenNameTextField.text avatar:self.avatarImage.image];
        
        ChatroomViewController *chatroomViewController = [[ChatroomViewController alloc] initWithChatroom:self.chatroom userName:self.screenNameTextField.text avatarImage:self.avatarImage.image];
        [self.navigationController pushViewController:chatroomViewController animated:YES];
    } else {
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
    newUser.profileImageId = @"";
    
    
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
 
    // TODO fix: *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'cannot setReadAccess for unsaved user'
    [self createDummyUserAndUploadImage:chosenImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}


#pragma - Image Management Methods

-(void) createDummyUserAndUploadImage:(UIImage *)image{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self uploadImage:image];
    } else {
        // Dummy username and password
        PFUser *user = [PFUser user];
        user.username = @"Matt";
        user.password = @"password";
        user.email = @"Matt@example.com";
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Error creating dummy user");
            } else {
                [PFUser logInWithUsername:@"Matt" password:@"password"];
                NSLog(@"Error creating dummy user");
                [self uploadImage:image];
            }
        }];
    }
}


- (void)uploadImage:(UIImage *)image{
    
    NSLog(@"uploadImage");
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"image saved in background with no error: %@", userPhoto.objectId);
                
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        NSLog(@"progress: %f", (float)percentDone/100);
    }];
}

@end
