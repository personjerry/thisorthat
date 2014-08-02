//
//  TOTPost.h
//  ThisOrThat
//
//  Created by Daniel Tyrrell on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOTPost : NSObject

@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *profileIcon;
@property (nonatomic, strong) NSString *description;

@end
