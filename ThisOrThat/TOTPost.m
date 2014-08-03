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

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        
        self.user = dictionary[@"user"];
        self.category = dictionary[@"category"];
        self.image1 = dictionary[@"image1"];
        self.image2 = dictionary[@"image2"];
        self.description = dictionary[@"description"];
        self.image1Votes = [dictionary[@"image1Votes"] intValue];
        self.image2Votes = [dictionary[@"image2Votes"] intValue];
        self.points = [dictionary[@"points"] intValue];
        
    }
    
    return self;
    
}

@end
