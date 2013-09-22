//
//  Trend.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 09/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "Trend.h"

@implementation Trend

-(id) initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        _name = [[data objectForKey:@"name"] copy];
        _url = [[data objectForKey:@"url"] copy];;
        _promotedContent = [[data objectForKey:@"promoted_content"] copy];
        _events = [[data objectForKey:@"events"] copy];
        _query = [[data objectForKey:@"query"] copy];
    }
    return self;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"Trend:<%p> NAME:%@ URL:%@ PROMOTED_CONTENT:%@ EVENTS:%@ QUERY:%@", self, _name, _url, _promotedContent, _events, _query];
}
@end
