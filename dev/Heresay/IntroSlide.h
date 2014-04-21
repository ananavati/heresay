//
//  IntroSlide.h
//  Heresay
//
//  Created by Thomas Ezan on 4/20/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroSlide : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *text;

- (id)initWithImageName:(NSString *)imageName text:(NSString *)text;

@end
