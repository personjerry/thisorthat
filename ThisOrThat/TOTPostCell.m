//
//  TOTPostCell.m
//  ThisOrThat
//
//  Created by Daniel Tyrrell on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTPostCell.h"

@implementation TOTPostCell

@synthesize user, category, image1, image2, profileIcon, description;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    self.image1.userInteractionEnabled = YES;
    self.image2.userInteractionEnabled = YES;
    prevFrame1 = self.image1.frame;
    prevFrame2 = self.image2.frame;
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (void) prepareForReuse {
    [super prepareForReuse];
    NSLog(@"in prepareForReuse");
    [self.image1 setFrame:prevFrame1];
    [self.image2 setFrame:prevFrame2];
    
}*/


@end
