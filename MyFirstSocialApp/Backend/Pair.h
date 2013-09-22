//
//  Pair.h
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/09/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pair : NSObject

@property(strong, nonatomic) id first;
@property(strong, nonatomic) id second;

- (id)initWithFirst:(id)first andSecond:(id) second;

@end
