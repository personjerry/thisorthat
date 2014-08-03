//
//  TOTParentFeedViewController.h
//  ThisOrThat
//
//  Created by Daniel Tyrrell on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOTPostCell.h"

@interface TOTParentFeedViewController : UITableViewController <UIGestureRecognizerDelegate> {

UITapGestureRecognizer *tap1;
UITapGestureRecognizer *tap2;
bool isFullScreen;
CGRect prevFrame;

}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *postArray;
@property (nonatomic) NSInteger reloadOffset;
@property (nonatomic, strong) TOTPostCell *currCell;


@end
