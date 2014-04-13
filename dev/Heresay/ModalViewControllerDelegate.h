//
//  ModalViewControllerDelegate.h
//  Heresay
//
//  Created by Eric Socolofsky on 4/13/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModalViewControllerDelegate;
@protocol ModalViewControllerDelegate <NSObject>

- (void)didDismissWithViewController:(UIViewController *)viewController;

@end

@interface ModalViewControllerDelegate : NSObject

@end
