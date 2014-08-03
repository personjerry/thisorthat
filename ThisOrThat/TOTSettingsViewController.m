//
//  TOTSecondViewController.m
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTSettingsViewController.h"
#import "TOTPost.h"
#import "TOTPostCell.h"

@interface TOTSettingsViewController ()

@property (nonatomic) int maxCount;

@property (nonatomic) BOOL inProgress;

@end

@implementation TOTSettingsViewController

@synthesize postArray, reloadOffset, tableView;



- (void) viewWillAppear:(BOOL)animated {
    [TOTPost fetchCountForObjectsWithCompletion:^(NSInteger count, NSError *error) {
        
        if (error == nil) {
            self.maxCount = (long)(count);
            [self getPosts];
        } else {
            
            NSLog(@"error is %@", error);
            
        }
        
    }];
    [self.postArray removeAllObjects];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.reloadOffset = 20;
    self.postArray = [[NSMutableArray alloc] init];
    [self getPosts];
    
    self.view.userInteractionEnabled = YES;
    
    isFullScreen1 = false;
    isFullScreen2 = false;
    /*swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipe1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipe2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe1];
    [self.tableView addGestureRecognizer:swipe2];*/
    
    tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageWasTapped:)];
    tap1.numberOfTapsRequired = 2;
    [self.tableView addGestureRecognizer:tap1];
    
    
    NSLog(@"Finished viewDidLoad");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self postArray] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger NumberOfLoadedRows = [tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row >= NumberOfLoadedRows - self.reloadOffset) {
        NSLog(@"In if statement");
        [self fetchMorePosts];
    }
    
    static NSString *CellIdentifier = @"Cell";
    TOTPostCell *cell = (TOTPostCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.description.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    TOTPost *post = [self.postArray objectAtIndex:indexPath.row];
    cell.user.text = [post user];
    BAAFile *picture = [[BAAFile alloc] init];
    picture.fileId = [post image1];
    [picture loadFileWithCompletion:^(NSData *data, NSError *error) {
        cell.image1.image = [[UIImage alloc] initWithData:data];
    }];
    picture.fileId = [post image2];
    [picture loadFileWithCompletion:^(NSData *data, NSError *error) {
        cell.image2.image = [[UIImage alloc] initWithData:data];
    }];
    cell.category.text = [post category];
    cell.description.text = [post description];
    cell.description.editable = NO;
    
    UIImageView *winner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"winner.png"]];
    if (post.image1Votes > post.image2Votes) {
        NSLog(@"Image 1 wins");
        [cell.image1 addSubview:winner];
    } else if (post.image1Votes < post.image2Votes) {
        NSLog(@"Image 2 wins");
        [cell.image2 addSubview:winner];
    } else {
        NSLog(@"TIE");
    }
    return cell;
}

- (void) imageWasTapped: (UITapGestureRecognizer *) tap {
    CGPoint tapLocation = [tap locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    if (indexPath)
    {
        TOTPostCell *cell = (TOTPostCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        CGRect image1RectInTableViewCoorSys = [self.tableView convertRect:cell.image1.frame fromView:cell];
        CGRect image2RectInTableViewCoorSys = [self.tableView convertRect:cell.image2.frame fromView:cell];
        if (CGRectContainsPoint(image1RectInTableViewCoorSys, tapLocation))
        {
            NSLog(@"HELLO, image1 was tapped.");
            if (!isFullScreen1) {
                [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                    //save previous frame
                    prevFrame1 = cell.image1.frame;
                    //self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                    [cell.image1 setFrame:[[UIScreen mainScreen] applicationFrame]];
                    self.tableView.scrollEnabled = NO;
                    cell.image1.layer.zPosition = 2;
                }completion:^(BOOL finished){
                    isFullScreen1 = true;
                }];
                return;
            } else {
                [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                    [cell.image1 setFrame:prevFrame1];
                    cell.image1.layer.zPosition = 1;
                }completion:^(BOOL finished){
                    isFullScreen1 = false;
                }];
                self.tableView.scrollEnabled = YES;
                return;
            }
        } else if (CGRectContainsPoint(image2RectInTableViewCoorSys, tapLocation)) {
            NSLog(@"HELLO, image2 was tapped.");
            if (!isFullScreen2) {
                [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                    //save previous frame
                    prevFrame2 = cell.image2.frame;
                    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                    [cell.image2 setFrame:[[UIScreen mainScreen] applicationFrame]];
                    self.tableView.scrollEnabled = NO;
                    cell.image2.layer.zPosition = 2;
                }completion:^(BOOL finished){
                    isFullScreen2 = true;
                }];
                return;
            } else {
                [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                    [cell.image2 setFrame:prevFrame2];
                    cell.image2.layer.zPosition = 1;
                }completion:^(BOOL finished){
                    isFullScreen2 = false;
                }];
                self.tableView.scrollEnabled = YES;
                return;
            }
        }
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self centerTable:velocity.y - scrollView.decelerationRate];
    });
}

- (void)centerTable: (float) velocity {
    [self.tableView setContentOffset:CGPointMake(0, velocity * 400) animated:YES];
    NSIndexPath *pathForCenterCell = [self.tableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.tableView.bounds), CGRectGetMidY(self.tableView.bounds))];
    
    [self.tableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

/*
- (void) swipeLeft:(UISwipeGestureRecognizer *) swipe {
    NSLog(@"Left swipe");
    CGPoint swipeLocation = [swipe locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    if (indexPath)
    {
        TOTPostCell *cell = (TOTPostCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        CGRect image1RectInTableViewCoorSys = [self.tableView convertRect:cell.image1.frame fromView:cell];
        if (CGRectContainsPoint(image1RectInTableViewCoorSys, swipeLocation)) {
            NSLog(@"HELLO, image1 was swiped left.");
            [self chooseLeft];
        }
    }
    
}

- (void) swipeRight:(UISwipeGestureRecognizer *) swipe {
    NSLog(@"Right swipe");
    CGPoint swipeLocation = [swipe locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    if (indexPath)
    {
        TOTPostCell *cell = (TOTPostCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        CGRect image2RectInTableViewCoorSys = [self.tableView convertRect:cell.image2.frame fromView:cell];
        if (CGRectContainsPoint(image2RectInTableViewCoorSys, swipeLocation)) {
            NSLog(@"HELLO, image2 was swiped right.");
            [self chooseRight];
        }
        
    }
}


- (void) chooseLeft {
    NSLog(@"Chose left");
}

- (void) chooseRight {
    NSLog(@"Chose right");
}
*/




- (void) getPosts {
    // Override this method for each getPosts method in Feed and Popular
    if (self.postArray.count < 3 && !self.inProgress) {
        self.inProgress = YES;
        NSLog(@"No I'm being abitch");
        NSDictionary *parameters = @{kPageNumberKey : @0,
                                     kPageSizeKey : @3};
        [TOTPost getObjectsWithParams:parameters
                           completion:^(NSArray *posts, NSError *error) {
                               if (error == nil) {
                                   [self.postArray addObjectsFromArray: posts];
                                   [self.tableView reloadData];
                                   self.inProgress = NO;
                               } else {
                                   // deal with error
                                   NSLog([error localizedDescription]);
                                   self.inProgress = NO;
                               }
                               
                           }];
    }
}

- (void) fetchMorePosts {
    // Fill in this method
    if (self.postArray.count < self.maxCount && !self.inProgress) {
        self.inProgress = YES;
        NSLog(@"I'm being a bitch");
        NSDictionary *parameters = @{kPageNumberKey : [NSNumber numberWithInt:self.postArray.count],
                                     kPageSizeKey : [NSNumber numberWithInt:self.maxCount - self.postArray.count > 3 ? 3 : self.maxCount - self.postArray.count ] };
        [TOTPost getObjectsWithParams:parameters
                           completion:^(NSArray *posts, NSError *error) {
                               if (error == nil) {
                                   [self.postArray addObjectsFromArray: posts];
                                   [self.tableView reloadData];
                                   self.inProgress = NO;
                               } else {
                                   // deal with error
                                   NSLog([error localizedDescription]);
                                   self.inProgress = NO;
                               }
                               
                           }];
    }
}





@end
