//
//  TOTParentFeedViewController.m
//  ThisOrThat
//
//  Created by Daniel Tyrrell on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTParentFeedViewController.h"
#import "TOTPost.h"
#import "TOTPostCell.h"
//#import <objc/runtime.h>
#import "QuartzCore/QuartzCore.h"

@interface TOTParentFeedViewController ()

@property (nonatomic) int maxCount;

@property (nonatomic) BOOL inProgress;

@end

@implementation TOTParentFeedViewController

@synthesize postArray, reloadOffset;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reloadOffset = 20;
    self.postArray = [[NSMutableArray alloc] init];
    
    self.view.userInteractionEnabled = YES;
    
    isFullScreen1 = false;
    isFullScreen2 = false;
    swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipe1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipe2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:swipe1];
    [self.tableView addGestureRecognizer:swipe2];
    
    tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageWasTapped:)];
    tap1.numberOfTapsRequired = 2;
    [self.tableView addGestureRecognizer:tap1];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

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
    
    // Configure the cell...
    cell.user.text = [[self.postArray objectAtIndex:indexPath.row] user];
    BAAFile *picture = [[BAAFile alloc] init];
    picture.fileId = [[self.postArray objectAtIndex:indexPath.row] image1];
    [picture loadFileWithCompletion:^(NSData *data, NSError *error) {
        cell.image1.image = [[UIImage alloc] initWithData:data];
    }];
    picture.fileId = [[self.postArray objectAtIndex:indexPath.row] image2];
    [picture loadFileWithCompletion:^(NSData *data, NSError *error) {
        cell.image2.image = [[UIImage alloc] initWithData:data];
    }];
    cell.category.text = [[self.postArray objectAtIndex:indexPath.row] category];
    cell.description.text = [[self.postArray objectAtIndex:indexPath.row] description];
    cell.description.editable = NO;

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
                    self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self centerTable:abs(velocity.y) - 0.5 * scrollView.decelerationRate];
    });
}

- (void)centerTable: (float) velocity {
    if (abs(velocity) < 2) {
    NSIndexPath *pathForCenterCell = [self.tableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.tableView.bounds), CGRectGetMidY(self.tableView.bounds))];
    
    [self.tableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self centerTable:velocity - self.tableView.decelerationRate];
        });
        
    }
}


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
            [self chooseLeft:cell];
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
            [self chooseRight:cell];
        }
        
    }
}


- (void) chooseLeft: (TOTPostCell *) cell {
    [cell addSubview:cell.image1];
    cell.clipsToBounds = YES;
}

- (void) chooseRight: (TOTPostCell *) cell {
    [cell addSubview:cell.image2];
    cell.clipsToBounds = YES;
}





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



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
