//
//  TOTFirstViewController.h
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKImagePickerViewController.h"

@interface TOTSnapViewController : UIViewController <PKImagePickerViewControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@end
