//
//  TOTPost.h
//  ThisOrThat
//
//  Created by Daniel Tyrrell on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOTPost : BAAObject

@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *image1;
@property (nonatomic, strong) NSString *image2;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) int points;

- (NSString *)collectionName;

@end
