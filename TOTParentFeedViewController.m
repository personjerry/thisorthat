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

@end

@implementation TOTParentFeedViewController

@synthesize postArray, reloadOffset, currCell;


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
    [self getPosts];
    
    self.view.userInteractionEnabled = YES;
    
    isFullScreen = false;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen)];
    tap.numberOfTapsRequired = 1;
    
    //
    //[self.tableView reloadData];
    
    
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
    currCell = cell;
    
    // Configure the cell...
    cell.user.text = [[self.postArray objectAtIndex:indexPath.row] user];
    cell.category.text = [[self.postArray objectAtIndex:indexPath.row] category];
    cell.image1.image = [[self.postArray objectAtIndex:indexPath.row] image1];
    cell.image2.image = [[self.postArray objectAtIndex:indexPath.row] image2];
    cell.profileIcon.image = [[self.postArray objectAtIndex:indexPath.row] profileIcon];
    cell.description.text = [[self.postArray objectAtIndex:indexPath.row] description];
    cell.description.editable = NO;
    
    cell.image1.userInteractionEnabled = YES;
    tap.delegate = cell.image1;
    [cell.image1 addGestureRecognizer:tap];
    
    /*
    UIImageView *image1View = cell.image1;
    
    UIImageView *image1Expand = [[UIImageView alloc] initWithImage:image1View.image];
    image1Expand.contentMode =image1View.contentMode;
    image1Expand.frame = [self.view convertRect:image1View.frame fromView:image1View.superview];
    image1Expand.userInteractionEnabled = YES;
    image1Expand.clipsToBounds = YES;
    
    objc_setAssociatedObject(image1Expand,
                             "original_frame",
                             [NSValue valueWithCGRect: image1Expand.frame],
                             OBJC_ASSOCIATION_RETAIN);
    [UIView transitionWithView: self.view
                      duration: 1.0
                       options: UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        
                        [self.view addSubview: image1Expand];
                        image1Expand.frame = self.view.bounds;
                        
                    } completion:^(BOOL finished) {
                        
                        UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector( onTap: )];
                        [image1Expand addGestureRecognizer: tgr];
                    }];
    */
    return cell;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    NSLog(@"in gestureRecognizer");
    BOOL shouldReceiveTouch = YES;
    
    if (gestureRecognizer == tap) {
        shouldReceiveTouch = (touch.view == currCell.image1);
    }
    NSLog(@"shouldreceivetouch: %s", shouldReceiveTouch ? "true" : "false");
    //return shouldReceiveTouch;
    return YES;
}

//-(IBAction)imgToFullScreen:(id)sender {
-(void)imgToFullScreen{
    NSLog(@"In imgtofullscreen");
    if (!isFullScreen) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
            prevFrame = currCell.image1.frame;
            self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            [currCell.image1 setFrame:[[UIScreen mainScreen] applicationFrame]];
            self.tableView.scrollEnabled = NO;
            currCell.image1.layer.zPosition = 2;
        }completion:^(BOOL finished){
            isFullScreen = true;
        }];
        return;
    } else {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [currCell.image1 setFrame:prevFrame];
        }completion:^(BOOL finished){
            isFullScreen = false;
        }];
        self.tableView.scrollEnabled = YES;
        return;
    }
}


- (void) chooseCell:(TOTPostCell *)currCell1 andImage:(UIImage *) chosen {
    if (chosen == currCell1.image1.image) {
        
    } else if (chosen == currCell1.image2.image) {
        
    } else {
        NSLog(@"This isn't either of the images. What happened?");
    }
}






- (void) getPosts {
    // Override this method for each getPosts method in Feed and Popular
    TOTPost *post1 = [[TOTPost alloc] init];
    TOTPost *post2 = [[TOTPost alloc] init];
    TOTPost *post3 = [[TOTPost alloc] init];
    
    post1.user = @"post1";
    post2.user = @"post2";
    post3.user = @"post3";
    
    post1.description = @"description1";
    post2.description = @"description2";
    post3.description = @"description3";
    
    post1.category = @"Books";
    post2.category = @"Clothes";
    post3.category = @"Food";
    
    post1.image1 = [UIImage imageNamed:@"testimage1.jpg"];
    post1.image2 = [UIImage imageNamed:@"testimage2.jpg"];
    post2.image1 = [UIImage imageNamed:@"testimage2.jpg"];
    post2.image2 = [UIImage imageNamed:@"testimage3.jpg"];
    post3.image1 = [UIImage imageNamed:@"testimage3.jpg"];
    post3.image2 = [UIImage imageNamed:@"testimage1.jpg"];
    
    
    [self.postArray addObject:post1];
    [self.postArray addObject:post2];
    [self.postArray addObject:post3];
}

- (void) fetchMorePosts {
    // Fill in this method
    NSLog(@"In fetchmoreposts");
    TOTPost *post1 = [[TOTPost alloc] init];
    TOTPost *post2 = [[TOTPost alloc] init];
    TOTPost *post3 = [[TOTPost alloc] init];
    
    post1.user = @"post4";
    post2.user = @"post5";
    post3.user = @"post6";
    
    post1.description = @"description4";
    post2.description = @"description5";
    post3.description = @"description6";
    
    post1.category = @"Books";
    post2.category = @"Clothes";
    post3.category = @"Food";
    
    post1.image1 = [UIImage imageNamed:@"testimage4.jpg"];
    post1.image2 = [UIImage imageNamed:@"testimage5.png"];
    post2.image1 = [UIImage imageNamed:@"testimage5.png"];
    post2.image2 = [UIImage imageNamed:@"testimage6.jpg"];
    post3.image1 = [UIImage imageNamed:@"testimage6.jpg"];
    post3.image2 = [UIImage imageNamed:@"testimage4.jpg"];
    
    
    [self.postArray addObject:post1];
    [self.postArray addObject:post2];
    [self.postArray addObject:post3];
    [self.tableView reloadData];
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
