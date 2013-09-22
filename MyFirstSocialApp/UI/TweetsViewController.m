//
//  TweetsViewController.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/09/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "TweetsViewController.h"
#import "Backend.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface TweetsViewController ()

@property (strong, nonatomic) NSMutableArray *tweetsData;
@property (strong, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tweetsData = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    self.tweetsTableView.separatorColor = [UIColor clearColor];
    self.tweetsTableView.backgroundView = nil;
    self.tweetsTableView.backgroundView = [[UIView alloc] init];
    
    
    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(refreshTweets)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [self.activityIndicatorView startAnimating];
    [[Backend sharedInstance] requestNewestTrendingTweetsForTrend:self.currentTrend.name
                                                andCallback:^(NSString *trend, NSArray *response)
                                            {
                                                [self.activityIndicatorView stopAnimating];
                                                [self.tweetsData addObjectsFromArray:response];
                                                [self.tweetsTableView reloadData];
                                            }];

}

-(void) refreshTweets
{
    [self.tweetsData removeAllObjects];
    [self.tweetsTableView reloadData];
    [[Backend sharedInstance] clearData];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.activityIndicatorView startAnimating];
    [[Backend sharedInstance] requestNewestTrendingTweetsForTrend:self.currentTrend.name
                                                      andCallback:^(NSString *trend, NSArray *response)
                                                {
                                                    [self.activityIndicatorView stopAnimating];
                                                    [self.tweetsData addObjectsFromArray:response];
                                                    [self.tweetsTableView reloadData];
                                                    self.navigationItem.rightBarButtonItem.enabled = YES;
                                                }];
    
}

-(void)setCurrentTrend:(Trend *)currentTrend
{
    _currentTrend = currentTrend;
    self.title = self.currentTrend.name;
}

-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.tweetsData count] -1)
    {
        [self.activityIndicatorView startAnimating];
        [[Backend sharedInstance] requestOlderTrendingTweetsForTrend:self.currentTrend.name
                                                         andCallback:^(NSString *trend, NSArray *response) {
                                                             if([self.currentTrend.name isEqualToString:trend])
                                                             {
                                                                 [self.activityIndicatorView stopAnimating];
                                                                 [self.tweetsData addObjectsFromArray:response];
                                                                 [self.tweetsTableView reloadData];
                                                             }
                                                             
                                                        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   static NSString *cellIdentifier = @"cell";
    TweetCell *cell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if([self.tweetsData count] > 0)
    {
        Tweet *t = (Tweet *)[self.tweetsData objectAtIndex:indexPath.row];
        cell.userThumb.image = t.userProfileImg;
        cell.text.text = t.text;
        cell.userName.text = t.userName;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweetsData count];
}

@end
