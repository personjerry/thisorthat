//
//  TOTFirstViewController.m
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTSnapViewController.h"
#import "TOTPost.h"

@interface TOTFirstViewController ()

@end

@implementation TOTFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) performPost {
    TOTPost *post = [[TOTPost alloc] init];
    [post saveObjectWithCompletion:^(TOTPost *p, NSError *error) {
        
        if (error == nil) {
            NSLog(@"saved post is %@", p);
        } else {
            // deal with error
        }
        
    }];
}

@end
