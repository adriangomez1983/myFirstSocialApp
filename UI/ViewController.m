//
//  ViewController.m
//  MyFirstSocialApp
//
//  Created by Néstor Adrián Gómez Elfi on 22/09/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "ViewController.h"
#import "Trend.h"
#import "Backend.h"
#import "TweetsViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *trendsData;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Trends";
        _trendsData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[UIView alloc] init];
    [self getTrends];
}

-(void)getTrends
{
    [self.activityIndicatorView startAnimating];
    [[Backend sharedInstance] requestTrends:^(NSArray * results)
     {
         [self.activityIndicatorView stopAnimating];
         [self.trendsData removeAllObjects];
         self.trendsData = [NSMutableArray arrayWithArray:results];
         [self.tableView reloadData];
     }];
}


#pragma mark - UITableViewDelegate methods implementation

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if([self.trendsData count] > 0)
    {
        cell.textLabel.text = [(Trend *)[self.trendsData objectAtIndex:indexPath.row] name];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.trendsData count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetsViewController *tweetsVC = [[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil];
    Trend *t = (Trend *)[self.trendsData objectAtIndex:indexPath.row];
    [tweetsVC setCurrentTrend:t];
    [self.navigationController pushViewController:tweetsVC animated:YES];
}


@end
