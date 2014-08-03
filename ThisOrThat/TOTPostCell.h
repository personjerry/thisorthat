//
//  TOTPostCell.h
//  ThisOrThat
//
//  Created by Daniel Tyrrell on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOTPostCell : UITableViewCell {
    CGRect prevFrame1;
    CGRect prevFrame2;
}

@property (nonatomic, strong) IBOutlet UILabel *user;
@property (nonatomic, strong) IBOutlet UILabel *category;
@property (nonatomic, strong) IBOutlet UIImageView *image1;
@property (nonatomic, strong) IBOutlet UIImageView *image2;
@property (nonatomic, strong) IBOutlet UIImageView *profileIcon;
@property (nonatomic, strong) IBOutlet UITextView *description;


@end
