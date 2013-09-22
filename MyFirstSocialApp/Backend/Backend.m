//
//  Backend.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/09/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "Backend.h"
#import "TrendingTweetsRequester.h"

@interface Backend ()
@property (strong, nonatomic) TrendingTweetsRequester *requester;
@end

@implementation Backend
{

}

static Backend *_instance = nil;

+(Backend *) sharedInstance
{
    if (!_instance)
    {
        _instance = [[Backend alloc] init];
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _requester = [[TrendingTweetsRequester alloc] init];
        _requester.loadImageProfiles = YES;
    }
    return self;
}

-(void) requestTrends:(void (^)(NSArray *))callback
{
    [self.requester requestTrends:callback];
}

//-(void) requestTrendingTweetsForTrend:(NSString *)trend
//                          andCallback:(void (^)(NSString *, NSArray *))callback
//{
//    [self.requester requestTrendingTweetsForTrend:trend andCallback:callback];
//}

-(void) clearData
{
    [self.requester clearData];
}

-(void) requestNewestTrendingTweetsForTrend:(NSString *)trend
                                andCallback:(void (^)(NSString *trend, NSArray *response))callback
{
    [self.requester requestNewestTrendingTweetsForTrend:trend andCallback:callback];
}

-(void) requestOlderTrendingTweetsForTrend:(NSString *)trend
                               andCallback:(void (^)(NSString *trend, NSArray *response))callback
{
    [self.requester requestOlderTrendingTweetsForTrend:trend andCallback:callback];
}
@end
