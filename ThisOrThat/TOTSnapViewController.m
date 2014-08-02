//
//  TOTFirstViewController.m
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTSnapViewController.h"

@interface TOTSnapViewController ()

@end

@implementation TOTSnapViewController (CameraDelegateMethods)

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [[picker parentViewController] dismissViewControllerAnimated:YES completion: nil];
}

- (void) viewDidAppear:(BOOL)animated {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion: nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    // You have the image. You can use this to present the image in the next view like you require in `#3`.
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
