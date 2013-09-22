//
//  Pair.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/09/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "Pair.h"

@implementation Pair

- (id)init
{
    self = [super init];
    if (self) {
        _first = nil;
        _second = nil;
    }
    return self;
}

- (id)initWithFirst:(id)first andSecond:(id) second
{
    self = [super init];
    if (self) {
        _first = first;
        _second = second;
    }
    return self;
}

@end
