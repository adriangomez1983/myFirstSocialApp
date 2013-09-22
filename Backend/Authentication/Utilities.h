//
//  Utilities.h
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/07/13.
//  Copyright (c) 2013 Néstor Adrián Gómez Elfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDate.h>

@interface Comparator: NSObject

-(NSComparisonResult) compare:(NSObject *) object1 withObject:(NSObject *) object2;

@end

@interface StringComparator: Comparator

+(StringComparator *) stringComparator;

@end

@interface Utilities : NSObject

+(NSString *)     getTimestampString;
+(NSString *)     generateRandomKeyOfLength:(NSUInteger) requiredLength;

+(void)           insertObject:(NSObject *) object inArray:(NSMutableArray *) array withLowIndex:(NSInteger)
                           lowIndex withHighIndex:(NSInteger) highIndex usingComparator:(Comparator *) comparator;
+(NSData *)       calculateHMACSHA1:(NSString *) data secret:(NSString *) key;
+(NSString*)      base64forData:(NSData*) theData;
+(NSString *)     urlEncode:(NSString *) value;
+(NSString *)     urlDecode:(NSString *) input;

@end
