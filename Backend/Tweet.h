//
//  Tweet.h
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/07/13.
//  Copyright (c) 2013 Néstor Adrián Gómez Elfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property(nonatomic, readonly) NSNumber *identifier;
@property(nonatomic, readonly) NSString *creationDate;
@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) NSString *userName;
@property(nonatomic, readonly) NSURL *userProfileImgUrl;
@property(nonatomic, readonly) UIImage *userProfileImg;

-(id) initWithData:(NSDictionary *)data;

-(void) loadProfileImage;

@end
