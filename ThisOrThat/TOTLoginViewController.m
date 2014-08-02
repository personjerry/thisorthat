//
//  TOTLoginViewController.m
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTLoginViewController.h"

@interface TOTLoginViewController ()

@end

@implementation TOTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performLogin:(id)sender {
    BAAClient *client = [BAAClient sharedClient];
    [client authenticateUser: self.userNameField.text
                    password: self.passwordField.text
                  completion:^(BOOL success, NSError *error) {
                      
                      if (success) {
                          UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
                          [self presentViewController:[mainStoryboard instantiateInitialViewController] animated:true completion:nil];
                      } else {
                          self.errorField.text = [NSString stringWithFormat: @"%@%@", @"Error: ", [error localizedDescription]];
                      }
                  }];
}


- (IBAction)performRegister:(id)sender {
    BAAClient *client = [BAAClient sharedClient];
    [client createUserWithUsername: self.userNameField.text
                          password: self.passwordField.text
                        completion: ^(BOOL success, NSError *error) {
                      
                      if (success) {
                          UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
                          [self presentViewController:[mainStoryboard instantiateInitialViewController] animated:true completion:nil];
                      } else {
                          self.errorField.text = [NSString stringWithFormat: @"%@%@", @"Error: ", [error localizedDescription]];
                      }
                  }];
}

@end



