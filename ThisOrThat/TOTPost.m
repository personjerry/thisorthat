//
//  TOTPost.m
//  ThisOrThat
//
//  Created by Daniel Tyrrell on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTPost.h"

@implementation TOTPost
- (NSString *)collectionName {
    return @"document/posts";
}

@synthesize user, category, image1, image2, description;

@end
