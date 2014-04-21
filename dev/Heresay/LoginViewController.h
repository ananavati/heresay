//
//  LoginViewController.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/11/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chatroom.h"

@interface LoginViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) Chatroom *chatroom;

@end
