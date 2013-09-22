//
//  OAuthData.h
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/07/13.
//  Copyright (c) 2013 Néstor Adrián Gómez Elfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthData : NSObject
{
@private
    NSString * _timestamp;
    NSString * _nonce;
}

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * consumerKey;
@property (nonatomic, strong) NSString * consumerSecret;
@property (nonatomic, strong) NSString * oauthTokenSecret;
@property (nonatomic, strong) NSString * oauthToken;
@property (nonatomic, strong) NSString * oauthVersion;

@property (nonatomic, readonly) NSString * timestamp;
@property (nonatomic, readonly) NSString * nonce;

+(id) data;
-(id) initData;
-(NSString *) getOauthAuthorizationHeader;

@end
