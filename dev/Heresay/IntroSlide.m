//
//  IntroSlide.m
//  Heresay
//
//  Created by Thomas Ezan on 4/20/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "IntroSlide.h"

@implementation IntroSlide


- (id)initWithImageName:(NSString *)imageName text:(NSString *)text{
    self = [super init];
    if (self)
    {
        _imageName = imageName;
        _text = text;
    }
    
    return self;
}


@end
