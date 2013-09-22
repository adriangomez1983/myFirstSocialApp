//
//  Tweet.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/07/13.
//  Copyright (c) 2013 Néstor Adrián Gómez Elfi. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id) initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        _identifier = [data objectForKey:@"id"];
        _creationDate = [data objectForKey:@"created_at"];
        _text = [data objectForKey:@"text"];
        _userName = [(NSDictionary *)[data objectForKey:@"user"] objectForKey:@"screen_name"];
        _userProfileImgUrl = [NSURL URLWithString:[(NSDictionary *)[data objectForKey:@"user"] objectForKey:@"profile_image_url"]];
        _userProfileImg = [UIImage imageNamed:@"twitterLogo.png"];
    }
    return self;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"Tweet:<%p> IDENTIFIER:%@ CREATION_DATE:%@ TEXT:%@ USER_NAME:%@ USER_PROFILE_IMAGE_URL:%@", self, _identifier, _creationDate, _text, _userName, _userProfileImgUrl];
}

-(void) loadProfileImage
{
    _userProfileImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:_userProfileImgUrl]];
}

@end
