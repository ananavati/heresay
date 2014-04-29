//
//  UIColor+HeresayColor.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/24/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "UIColor+HeresayColor.h"

@implementation UIColor (HeresayColor)

+ (UIColor *)lightBackgroundColor {
	return [UIColor colorWithRed:245.0/255.0 green:248.0/255.0 blue:250.0/255.0 alpha:1.0];
}

+ (UIColor *)medDarkBackgroundColor {
	return [UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:77.0/255.0 alpha:1.0];
}

+ (UIColor *)darkBackgroundColor {
	return [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:51.0/255.0 alpha:1.0];
}

+ (UIColor *)orangeAccentColor {
	return [UIColor colorWithRed:255.0/255.0 green:148.0/255.0 blue:51.0/255.0 alpha:1.0];
}

+ (UIColor *)orangeOverlayWeakColor {
	return [UIColor colorWithRed:255.0/255.0 green:148.0/255.0 blue:51.0/255.0 alpha:0.4];
}

+ (UIColor *)orangeOverlayStrongColor {
	return [UIColor colorWithRed:255.0/255.0 green:148.0/255.0 blue:51.0/255.0 alpha:0.8];
}

+ (UIColor *)blueHighlightColor {
	return [UIColor colorWithRed:74.0/255.0 green:170.0/255.0 blue:224.0/255.0 alpha:1.0];
}

+ (UIColor *)blueOverlayWeakColor {
	return [UIColor colorWithRed:74.0/255.0 green:170.0/255.0 blue:224.0/255.0 alpha:0.40];
}

+ (UIColor *)blueOverlayStrongColor {
	return [UIColor colorWithRed:74.0/255.0 green:170.0/255.0 blue:224.0/255.0 alpha:0.80];
}

@end