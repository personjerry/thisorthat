//
//  TOTFirstViewController.m
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTSnapViewController.h"
#import "TOTPost.h"

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
    [self.image1.layer setBorderColor: [[[[UIApplication sharedApplication] delegate] window].tintColor CGColor]];
    [self.image1.layer setBorderWidth: 1.0];
    [self.image1.layer setCornerRadius:30.0f];
    [self.image2.layer setBorderColor: [[[[UIApplication sharedApplication] delegate] window].tintColor CGColor]];
    [self.image2.layer setBorderWidth: 1.0];
    [self.image2.layer setCornerRadius:30.0f];
    [self.descriptionField.layer setBorderColor: [[[[UIApplication sharedApplication] delegate] window].tintColor CGColor]];
    [self.descriptionField.layer setBorderWidth: 1.0];
    [self.descriptionField.layer setCornerRadius:5.0f];
    [self.fashionButton.layer setBorderColor: [[[[UIApplication sharedApplication] delegate] window].tintColor CGColor]];
    [self.fashionButton.layer setBorderWidth: 1.0];
    [self.fashionButton.layer setCornerRadius:5.0f];
    [self.fashionButton setTitleColor:[UIColor TOTPurpleColor] forState:UIControlStateHighlighted];
    [self.fashionButton setBackgroundImage: [UIImage imageWithColor:[UIColor whiteColor]] forState: UIControlStateHighlighted];
    [self.artButton.layer setBorderColor: [[[[UIApplication sharedApplication] delegate] window].tintColor CGColor]];
    [self.artButton.layer setBorderWidth: 1.0];
    [self.artButton.layer setCornerRadius:5.0f];
    [self.artButton setTitleColor:[UIColor TOTPurpleColor] forState:UIControlStateHighlighted];
    [self.artButton setBackgroundImage: [UIImage imageWithColor:[UIColor whiteColor]] forState: UIControlStateHighlighted];
    [self.foodButton.layer setBorderColor: [[[[UIApplication sharedApplication] delegate] window].tintColor CGColor]];
    [self.foodButton.layer setBorderWidth: 1.0];
    [self.foodButton.layer setCornerRadius:5.0f];
    [self.foodButton setTitleColor:[UIColor TOTPurpleColor] forState:UIControlStateHighlighted];
    [self.foodButton setBackgroundImage: [UIImage imageWithColor:[UIColor whiteColor]] forState: UIControlStateHighlighted];
    [self.miscButton.layer setBorderColor: [[[[UIApplication sharedApplication] delegate] window].tintColor CGColor]];
    [self.miscButton.layer setBorderWidth: 1.0];
    [self.miscButton.layer setCornerRadius:5.0f];
    [self.miscButton setTitleColor:[UIColor TOTPurpleColor] forState:UIControlStateHighlighted];
    [self.miscButton setBackgroundImage: [UIImage imageWithColor:[UIColor whiteColor]] forState: UIControlStateHighlighted];
    
    
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
            [self.image1.layer setCornerRadius:30.0f];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [alertView cancelButtonIndex] || [alertView textFieldAtIndex:0].text.intValue == 0) {
        self.pointsAllocation.selectedSegmentIndex = 0;
        [self.pointsAllocation setTitle: @"Custom" forSegmentAtIndex:4];
    } else {
        self.pointsAllocation.selectedSegmentIndex = 4;
        [self.pointsAllocation setTitle: [alertView textFieldAtIndex:0].text forSegmentAtIndex:4];
    }
    // else do your stuff for the rest of the buttons (firstOtherButtonIndex, secondOtherButtonIndex, etc)
}

- (IBAction)pointsAllocationChanged:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Points" message:@"Enter custom amount:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    if ([[self.pointsAllocation titleForSegmentAtIndex:4] intValue] != 0) {
        [alertView textFieldAtIndex:0].text = [self.pointsAllocation titleForSegmentAtIndex:4];
    }
    [alertView show];
}

- (IBAction)reselectImage1:(id)sender {
    self.targetImageIndex = 1;
    [self pickImage];
}

- (IBAction)reselectImage2:(id)sender {
    self.targetImageIndex = 2;
    [self pickImage];
}

- (IBAction)submitPost:(UIButton *)sender {
    BAAFile *file = [[BAAFile alloc] initWithData: UIImageJPEGRepresentation(self.image1.image, 0.9)];
    file.contentType = @"image/jpeg";
    
    [file uploadFileWithPermissions: nil
                         completion:^(BAAFile *uploadedFile, NSError *error) {
                             
                             if (error == nil) {
                                 [self submitStep2:sender.titleLabel.text withFirstImage:[uploadedFile fileId]];
                             } else {
                                 // Deal with error
                             }
                             
                         }];
}

- (void)submitStep2:(NSString*)category withFirstImage:(NSString*)imageId1 {
    BAAFile *file = [[BAAFile alloc] initWithData: UIImageJPEGRepresentation(self.image2.image, 0.9)];
    file.contentType = @"image/jpeg";
    
    [file uploadFileWithPermissions: nil
                         completion:^(BAAFile *uploadedFile, NSError *error) {
                             
                             if (error == nil) {
                                 [self submitStep3:category withFirstImage:imageId1 withSecondImage: [uploadedFile fileId]];
                             } else {
                                 // Deal with error
                             }
                             
                         }];
    
}

- (void)submitStep3:(NSString*)category withFirstImage:(NSString*)imageId1 withSecondImage:imageId2 {
    BAAUser *user = [[BAAClient sharedClient] currentUser];
    TOTPost *post = [[TOTPost alloc] init];
    post.user = user.username;
    post.category = category;
    post.image1 = imageId1;
    post.image2 = imageId2;
    post.points = [[self.pointsAllocation titleForSegmentAtIndex:[self.pointsAllocation selectedSegmentIndex]] intValue] * 600.0 + [[NSDate date] timeIntervalSince1970];
    post.description = self.descriptionField.text;
    
    [post saveObjectWithCompletion:^(TOTPost *p, NSError *error) {
        
        if (error == nil) {
            self.tabBarController.selectedIndex = 0;
        } else {
            // deal with error
            NSLog([error localizedDescription]);
        }
        
    }];
    
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
