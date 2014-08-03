//
//  TOTSecondViewController.h
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOTSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITapGestureRecognizer *tap1;
    bool isFullScreen1;
    bool isFullScreen2;
    CGRect prevFrame1;
    CGRect prevFrame2;
    
    UISwipeGestureRecognizer *swipe1;
    UISwipeGestureRecognizer *swipe2;
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *postArray;
@property (nonatomic) NSInteger reloadOffset;


@end
