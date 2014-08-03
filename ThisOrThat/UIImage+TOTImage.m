//
//  UIImage+TOTImage.m
//  ThisOrThat
//
//  Created by Jerry Liu on 8/3/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "UIImage+TOTImage.h"

@implementation UIImage (TOTImage)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
