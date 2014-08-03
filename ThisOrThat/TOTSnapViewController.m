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
@property (nonatomic) int targetImageIndex;
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
    [self.image1.layer setBorderColor: [[UIColor TOTPurpleColor] CGColor]];
    [self.image1.layer setBorderWidth: 2.0];
    [self.image2.layer setBorderColor: [[UIColor TOTPurpleColor] CGColor]];
    [self.image2.layer setBorderWidth: 2.0];
    [self.descriptionField.layer setBorderColor: [[UIColor TOTPurpleColor] CGColor]];
    [self.descriptionField.layer setBorderWidth: 2.0];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //Clear out the UI first
    if (self.targetImageIndex == 0) {
        if (self.initialImageLoad) {
            self.initialImageLoad = NO;
            [self pickImage];
        } else if (self.continueImageLoad) {
            self.continueImageLoad = NO;
            self.selectedImageIndex = 1;
            [self pickImage];
        } else {
            self.selectedImageIndex = 2;
        }
    } else {
        self.selectedImageIndex = self.targetImageIndex;
    }
}

- (void) pickImage {
    self.imagePickerController = [[PKImagePickerViewController alloc]init];
    
    self.imagePickerController.delegate = self;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void) imageSelectionCancelled {
    self.continueImageLoad = NO;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 40) ? NO : YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)reselectImage1:(id)sender {
    self.targetImageIndex = 1;
    [self pickImage];
}

- (IBAction)reselectImage2:(id)sender {
    self.targetImageIndex = 2;
    [self pickImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
