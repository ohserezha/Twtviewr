//
//  MainViewController.m
//  Twtviewr
//
//  Created by ezkeemo on 9/3/15.
//  Copyright (c) 2015 ezkeemo. All rights reserved.
//

#import "MainViewController.h"
#import <Social/Social.h>
#import "DetailsViewController.h"
#import "ApiManager.h"
#import "NewTweetViewController.h"
#import "DataManager.h"

#warning Uses bad solution for messing with tweet's data switching from dictionary to nsmanagedobject

@interface MainViewController () <NewTweetViewControllerDelegate>
@property (strong, nonatomic) NSArray *tweetsArray;
@property (assign, nonatomic) BOOL networkAvailable;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWithBaseAccount) name:kTwitterAccountIsReadyNotification object:nil];
    self.networkAvailable = [[ApiManager sharedInstance] isConnectedToNetwork];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTweets {
    // here we determine where from to load web or local
    // will implement saving on load or applicationwillenterbackgrnd
    if (self.networkAvailable) {
        ApiManager *apiMgr = [ApiManager sharedInstance];
        [apiMgr getFeedForUserAccount:apiMgr.twitterAccount onCompletion:^(NSArray *array) {
            self.tweetsArray = [NSArray arrayWithArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            [[DataManager sharedInstance] putTweetsArray:self.tweetsArray];
        } onFailure:^(NSError *error) {
            NSLog(@"error getting user's feed occured %@", [error localizedDescription]);
        }];
    } else {
        // fetch data from database
        self.tweetsArray = [[DataManager sharedInstance] fetchTweetsArrayAscendingID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)loginWithBaseAccount {
    [[ApiManager sharedInstance] loginViaBaseTwitterAccountWithCompletionBlock:^{
        NSLog(@"loggin %d network", self.networkAvailable);
        [self loadTweets];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.tweetsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    }
    NSInteger idx = indexPath.row;
    cell.tag = idx;
    
    if (self.networkAvailable) {
        NSDictionary *tweet = self.tweetsArray[idx];
        if (tweet) {
            NSURL *imageURL = [NSURL URLWithString:tweet[@"user"][@"profile_image_url"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = image;
                    [cell setNeedsLayout];
                });
            });
            cell.textLabel.text = tweet[@"user"][@"screen_name"];
            cell.detailTextLabel.text = tweet[@"text"];
        }
    } else {
        Tweet *tweet = self.tweetsArray[idx];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:tweet.profileImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
                [cell setNeedsLayout];
            });
        });
        cell.textLabel.text = tweet.username;
        cell.detailTextLabel.text = tweet.text;
    }
    
    return cell;
}

#pragma mark - NewTweetViewControllerDelegate

- (void)didSuccessfullyPost {
    [self loadTweets];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                    message:@"Your tweet has been successfully posted!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Hurrraaaay!"
                                          otherButtonTitles:nil];
    [alert show];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowDetailsSegue"]) {
        DetailsViewController *detailsVC = (DetailsViewController *)[segue destinationViewController];
        NSInteger selectedRowIndex = [self.tableView indexPathForSelectedRow].row;
        if ([self.tweetsArray[selectedRowIndex] isKindOfClass:[NSDictionary class]]) {
            detailsVC.tweet = self.tweetsArray[selectedRowIndex];
        } else {
            detailsVC.tweet = [self convertTweetIntoTweetDict:self.tweetsArray[selectedRowIndex]];
        }
    } else if ([segue.identifier isEqualToString:@"NewTweetSegue"]) {
        NewTweetViewController *newTweetVC = (NewTweetViewController *)[segue destinationViewController];
        newTweetVC.delegate = self;
    }
}


#pragma mark - Helpers

- (NSDictionary *)convertTweetIntoTweetDict:(Tweet *)tweet {
    NSDictionary *tweetDict = @{@"created_at":tweet.createdAt,
                                @"id":tweet.idn,
                                @"in_reply_to_screen_name":tweet.inReplyTo ? tweet.inReplyTo : @"",
                                @"text":tweet.text,
                                @"user": @{@"profile_image_url":@"empty",},
                                           @"screen_name":tweet.username};
    return tweetDict;
}
@end
