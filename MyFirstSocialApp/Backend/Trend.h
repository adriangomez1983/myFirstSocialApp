//
//  Trend.h
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 09/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trend : NSObject

@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *url;
@property(nonatomic, readonly) NSString *promotedContent;
@property(nonatomic, readonly) NSString *query;
@property(nonatomic, readonly) NSString *events;

-(id) initWithData:(NSDictionary *)data;

@end
