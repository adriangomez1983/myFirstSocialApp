//
//  TweetCell.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 09/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"TweetCellView" owner:self options:nil];
    self = [nibArray objectAtIndex:0];
    
    self.userThumb.image = [UIImage imageNamed:@"twitterLogo.png"];

    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
