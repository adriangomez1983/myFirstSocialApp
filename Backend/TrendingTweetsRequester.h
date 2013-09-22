//
//  TrendTweetsRequester.h
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/07/13.
//  Copyright (c) 2013 Néstor Adrián Gómez Elfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendingTweetsRequester : NSObject

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic) BOOL loadImageProfiles;

-(void) requestTrends:(void (^)(NSArray *response)) callback;

-(void) requestNewestTrendingTweetsForTrend:(NSString *)trend andCallback:(void (^)(NSString *trend, NSArray *response))callback;

-(void) requestOlderTrendingTweetsForTrend:(NSString *)trend andCallback:(void (^)(NSString *trend, NSArray *response))callback;

-(void) clearData;

@end
