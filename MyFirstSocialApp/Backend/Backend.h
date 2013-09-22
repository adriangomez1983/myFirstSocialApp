//
//  Backend.h
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/09/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Backend : NSObject

+(Backend *) sharedInstance;

-(void) requestTrends:(void (^)(NSArray *response)) callback;
-(void) requestNewestTrendingTweetsForTrend:(NSString *)trend
                                andCallback:(void (^)(NSString *trend, NSArray *response))callback;
-(void) requestOlderTrendingTweetsForTrend:(NSString *)trend
                               andCallback:(void (^)(NSString *trend, NSArray *response))callback;

-(void) clearData;

@end
