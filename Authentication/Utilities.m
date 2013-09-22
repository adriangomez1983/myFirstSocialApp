//
//  Utilities.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/07/13.
//  Copyright (c) 2013 Néstor Adrián Gómez Elfi. All rights reserved.
//

#import "Utilities.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <sys/utsname.h>
#include <mach/mach.h>

@implementation Comparator

-(NSComparisonResult) compare:(NSObject *) object1 withObject:(NSObject *) object2
{
    return NSOrderedAscending;
}

@end

@implementation StringComparator

+(StringComparator *) stringComparator
{
    return [[StringComparator alloc] init];
}

-(NSComparisonResult) compare:(NSObject *) object1 withObject:(NSObject *) object2
{
    return [(NSString *) object1 compare:(NSString *) object2];
}

@end

@implementation Utilities


static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

+(NSString *) getTimestampString
{
    NSTimeInterval localTime = [[NSDate date] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:localTime]];
}

+(NSData *) calculateHMACSHA1:(NSString *)data secret:(NSString *)key
{
    
    const char *cKey  = [key UTF8String];
    const char *cData = [data UTF8String];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    return [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
}


+(NSString*) base64forData:(NSData*) inputData
{
    const uint8_t* input = (const uint8_t*)[inputData bytes];
    NSInteger length = [inputData length];
    
    static char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*) data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3)
    {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++)
        {
            value <<= 8;
            
            if (j < length)
            {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger outputIndex = (i / 3) * 4;
        
        output[outputIndex + 0] =                    alphabet[(value >> 18) & 0x3F];
        output[outputIndex + 1] =                    alphabet[(value >> 12) & 0x3F];
        output[outputIndex + 2] = (i + 1) < length ? alphabet[(value >> 6)  & 0x3F] : '=';
        output[outputIndex + 3] = (i + 2) < length ? alphabet[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+(void) insertObject:(NSObject *) object inArray:(NSMutableArray *) array withLowIndex:(NSInteger) lowIndex withHighIndex:(NSInteger) highIndex usingComparator:(Comparator *) comparator keepDuplicates:(BOOL) keepDuplicates
{
    if(object != nil)
    {
        if(lowIndex > highIndex)
        {
            [array insertObject:object atIndex:lowIndex];
        }
        else if(lowIndex + 1 > highIndex)
        {
            NSComparisonResult comparisonResult = [comparator compare:object withObject:[array objectAtIndex:lowIndex]];
            
            if(comparisonResult == NSOrderedDescending)
            {
                [array insertObject:object atIndex:lowIndex + 1];
            }
            else
            {
                if(keepDuplicates || comparisonResult == NSOrderedAscending)
                {
                    [array insertObject:object atIndex:lowIndex];
                }
            }
        }
        else
        {
            NSInteger middleIndex = (lowIndex + highIndex) / 2;
            
            NSComparisonResult comparisonResult = [comparator compare:object withObject:[array objectAtIndex:middleIndex]];
            
            if(comparisonResult == NSOrderedDescending)
            {
                [Utilities insertObject:object inArray:array withLowIndex:middleIndex + 1 withHighIndex:highIndex usingComparator:comparator keepDuplicates:keepDuplicates];
            }
            else if(comparisonResult == NSOrderedAscending)
            {
                [Utilities insertObject:object inArray:array withLowIndex:lowIndex withHighIndex:middleIndex - 1 usingComparator:comparator
                    keepDuplicates:keepDuplicates];
            }
            else
            {
                if(keepDuplicates)
                {
                    [array insertObject:object atIndex:middleIndex];
                }
            }
        }
    }
}
//
///**
// *  Inserts a new object in the order given by a comparator, avoiding duplicates
// */
+(void) insertObject:(NSObject *) object inArray:(NSMutableArray *) array withLowIndex:(NSInteger) lowIndex withHighIndex:(NSInteger) highIndex usingComparator:(Comparator *) comparator
{
    [Utilities insertObject:object inArray:array withLowIndex:lowIndex withHighIndex:highIndex usingComparator:comparator
                keepDuplicates:NO];
}

+(NSString *) generateRandomKeyOfLength:(NSUInteger) requiredLength
{
    static const char* source = "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y4z5"
                                "A1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6Q7R8S9T0U1V2W3X4Y4Z5";
    size_t sourceLength = strlen(source);

    NSMutableString * result = [NSMutableString string];
    
    NSUInteger length = (requiredLength == 0 || requiredLength > 256) ? 10 : requiredLength;
    
    for(NSUInteger index = 0; index < length; ++index)
    {
        [result appendFormat:@"%c", source[arc4random() % sourceLength]];
    }
    
    return result;
}

+(NSString *) urlEncode:(NSString *) value
{
    return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)value, NULL,
                                                                         CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
}

+ (NSString *) urlDecode:(NSString *) input
{
    NSString *result = [input stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
