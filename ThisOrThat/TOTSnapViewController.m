//
//  TOTFirstViewController.m
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTSnapViewController.h"
@interface TOTSnapViewController ()

@property (strong, nonatomic) PKImagePickerViewController *imagePickerController;
@property (nonatomic) int selectedImageIndex;
@property (nonatomic) BOOL initialImageLoad;
@property (nonatomic) BOOL continueImageLoad;

@end

@implementation TOTSnapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.initialImageLoad = YES;
    self.continueImageLoad = YES;
}

- (void) imageSelectionCancelled {
    self.continueImageLoad = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //Clear out the UI first
    if (self.initialImageLoad) {
        self.initialImageLoad = NO;
        self.imagePickerController = [[PKImagePickerViewController alloc]init];
        
        self.imagePickerController.delegate = self;
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else if (self.continueImageLoad) {
        self.continueImageLoad = NO;
        self.selectedImageIndex = 1;
        self.imagePickerController = [[PKImagePickerViewController alloc]init];
        
        self.imagePickerController.delegate = self;
        
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        self.selectedImageIndex = 2;
    }
    
}

- (void) viewDidDisappear:(BOOL)animated {
    if (self.tabBarController.selectedIndex != 2) {
        self.initialImageLoad = YES;
        self.continueImageLoad = YES;
        self.image1.image = nil;
        self.image2.image = nil;
    }
}

- (void) imageSelected:(UIImage *)img {
    if (self.selectedImageIndex != 0) {
        if (self.selectedImageIndex == 1) {
            self.image1.image = img;
        } else if (self.selectedImageIndex == 2) {
            self.image2.image = img;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
