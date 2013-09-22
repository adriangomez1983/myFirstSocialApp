//
//  TrendTweetsRequester.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/07/13.
//  Copyright (c) 2013 Néstor Adrián Gómez Elfi. All rights reserved.
//

#import "TrendingTweetsRequester.h"
#import "Tweet.h"
#import "Trend.h"
#import "OAuthData.h"
#import "Utilities.h"

#import "Pair.h"

#define MAX_CONCURRENT_OPERATIONS 3
#define TWEETS_COUNT 15

static NSString *consumerKey = @"KCiKbXT6Yot9NQKq7r2rwA";
static NSString *consumerSecret = @"U9LVYPmWQMZ49xInpXvnzzFAS28b35V0yyDPcezdoc";
static NSString *oauthToken =@"792289568-NThMYpJmuujvZrofF6WlLRv18vI2UlEGueNUXJ0A";
static NSString *oauthTokenSecret = @"PRPKuBX7dKfEcV45YZKMhUkwiZiBAf9T2Oah8HBNeU";

@interface TrendingTweetsRequester ()

@property (strong, nonatomic) NSOperationQueue *backgroundQueue;

//{Trend : <since_id, max_id>}
@property (strong, nonatomic) NSMutableDictionary *trendsIdMap;


@end

@implementation TrendingTweetsRequester

-(id) init
{
    self = [super init];
    if (self)
    {
        _url = [NSURL URLWithString:@"https://api.twitter.com/1.1/trends/place.json?id=1"];
        _backgroundQueue = [[NSOperationQueue alloc] init];
        [_backgroundQueue setMaxConcurrentOperationCount:MAX_CONCURRENT_OPERATIONS];
        _loadImageProfiles = NO;
        _trendsIdMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString *) getOAuthSignatureForUrl:(NSURL *) url
{
    OAuthData *oauth = [[OAuthData alloc] initData];
    oauth.consumerKey = consumerKey;
    oauth.consumerSecret = consumerSecret;
    oauth.url = url;
    oauth.oauthToken = oauthToken;
    oauth.oauthTokenSecret = oauthTokenSecret;
    
    return [oauth getOauthAuthorizationHeader];
    
}

-(NSURL *) getSearchURLForNewestTweets:(BOOL) searchForNewTweets
                          forTrendName:(NSString *) trend
{
    NSURL *searchURL = [NSURL URLWithString:@""];
    Pair *trendPair = (Pair *)[self.trendsIdMap objectForKey:trend];
    if([trendPair.first isEqualToString:@""])
    {
        searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?count=%d&q=%@", TWEETS_COUNT, [Utilities urlEncode:trend]]];
    }
    else if (searchForNewTweets)
    {
        NSString *sinceIdString = (NSString *)trendPair.first;
        searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?count=%d&since_id=%@&q=%@", TWEETS_COUNT, sinceIdString, [Utilities urlEncode:trend]]];
    }
    else
    {
        NSString *maxIdString = (NSString *)trendPair.second;
        searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?count=%d&max_id=%@&q=%@", TWEETS_COUNT, maxIdString, [Utilities urlEncode:trend]]];
    }
    return searchURL;
}

-(void) performSearchRequest:(NSString *) trend
               searchForward:(BOOL)
    forwardSearch andResults:(NSMutableArray *)results
{
    
    NSURL *searchURL = [self getSearchURLForNewestTweets:forwardSearch forTrendName:trend];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:searchURL];
    
    [request addValue:[self getOAuthSignatureForUrl:searchURL] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse* response = [[NSURLResponse alloc] init];
    NSError *requestError = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    if(!requestError)
    {
        NSError *error = [[NSError alloc] init];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
        NSArray *statuses = [jsonDict objectForKey:@"statuses"];

        for(NSDictionary *t in statuses)
        {
            Tweet *tweet = [[Tweet alloc] initWithData:t];
            if(_loadImageProfiles == YES)
            {
                [tweet loadProfileImage];
            }
            [results addObject:tweet];
        }
    }
    else
    {
        NSLog(@"Request error - Code: %d Domain:%@", requestError.code, requestError.domain);
    }
}

-(void) requestTrends:(void (^)(NSArray *response)) callback
{
    NSBlockOperation * myBlockOperation = [NSBlockOperation blockOperationWithBlock: [^(void){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
        
        [request addValue:[self getOAuthSignatureForUrl:_url] forHTTPHeaderField:@"Authorization"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse* response = nil;
        NSError *requestError = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
        if(!requestError)
        {
            NSError *error = [[NSError alloc] init];
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
            
            if (!jsonArray)
            {
                NSLog(@"Error parsing JSON: %@", error);
            }
            else
            {
                NSMutableArray *results = [[NSMutableArray alloc] init];
                for(NSDictionary *item in jsonArray) {
                    NSArray *trends = [item objectForKey:@"trends"];
                    if(trends && [trends count] > 0)
                    {
                        for(NSDictionary *t in trends)
                        {
                            Trend *trend = [[Trend alloc] initWithData:t];
                            [results addObject:trend];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^(void)
                               {
                                   callback(results);
                               }
                );
            }
        }
        else
        {
            NSLog(@"Request error - Code: %d Domain:%@", requestError.code, requestError.domain);
        }
        
        
    } copy]];
    
    [self.backgroundQueue addOperation:myBlockOperation];
}



-(void) requestNewestTrendingTweetsForTrend:(NSString *)trend
                                andCallback:(void (^)(NSString *trend, NSArray *response))callback
{
    NSBlockOperation * myBlockOperation = [NSBlockOperation blockOperationWithBlock: [^(void) {
    
        Pair *pair = (Pair *)[self.trendsIdMap objectForKey:trend];
        if (!pair)
        {
            Pair *newTrendPair = [[Pair alloc] initWithFirst:@"" andSecond:@""];
            [self.trendsIdMap setObject:newTrendPair forKey:trend];
        }
        NSMutableArray *results = [[NSMutableArray alloc] init];
        [self performSearchRequest:trend searchForward:YES andResults:results];
        if([results count] > 0)
        {
            Pair *p = [self.trendsIdMap objectForKey:trend];
            p.first = [[(Tweet *)[results objectAtIndex:0] identifier] stringValue];
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               callback(trend, results);
                           }
            );

        }
    } copy]];
    
    [self.backgroundQueue addOperation:myBlockOperation];
}

-(void) requestOlderTrendingTweetsForTrend:(NSString *)trend
                               andCallback:(void (^)(NSString *trend, NSArray *response))callback
{
    NSBlockOperation * myBlockOperation = [NSBlockOperation blockOperationWithBlock: [^(void) {
        
        Pair *pair = (Pair *)[self.trendsIdMap objectForKey:trend];
        if (!pair)
        {
            Pair *newTrendPair = [[Pair alloc] initWithFirst:@"" andSecond:@""];
            [self.trendsIdMap setObject:newTrendPair forKey:trend];
        }
        NSMutableArray *results = [[NSMutableArray alloc] init];
        [self performSearchRequest:trend searchForward:NO andResults:results];
        if([results count] > 0)
        {
            Pair *p = [self.trendsIdMap objectForKey:trend];
            long long maxID = [[(Tweet *)[results lastObject] identifier] longLongValue] - 1;
            p.second = [NSString stringWithFormat:@"%llu", maxID];
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               callback(trend, results);
                           }
            );
            
        }
    } copy]];
    
    [self.backgroundQueue addOperation:myBlockOperation];
}

-(void) clearData
{
    [self.trendsIdMap removeAllObjects];
}


@end
