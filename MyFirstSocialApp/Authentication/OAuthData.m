//
//  OAuthData.m
//  MyTrendingTweets
//
//  Created by Néstor Adrián Gómez Elfi on 07/07/13.
//  Copyright (c) 2013 Néstor Adrián Gómez Elfi. All rights reserved.
//

#import "OAuthData.h"
#import "Utilities.h"

@implementation OAuthData

@synthesize url;
@synthesize consumerKey;
@synthesize consumerSecret;
@synthesize oauthTokenSecret;
@synthesize oauthToken;
@synthesize oauthVersion;
@synthesize timestamp = _timestamp;
@synthesize nonce = _nonce;

+(id) data
{
    return [[OAuthData alloc] initData];
}

-(id) initData
{
    if(self = [super init])
    {
        self.url = nil;
        self.consumerKey = nil;
        self.consumerSecret = nil;
        self.oauthTokenSecret = nil;
        self.oauthToken = nil;
        self.oauthVersion = @"1.0";
        _timestamp = [Utilities getTimestampString];
        _nonce = [Utilities generateRandomKeyOfLength:15];
    }
    
    return self;
}

-(NSString *) encodeParameter:(NSString *) parameter
{
    NSString * encodedParameter;
    
    NSMutableArray * parameterAndValueArray = [NSMutableArray arrayWithArray:[parameter componentsSeparatedByString:@"="]];
    
    if([parameterAndValueArray count] == 2)
    {
        [parameterAndValueArray setObject:[Utilities urlEncode:[parameterAndValueArray objectAtIndex:1]] atIndexedSubscript:1];
        encodedParameter = [parameterAndValueArray componentsJoinedByString:@"="];
    }
    else
    {
        encodedParameter = [NSString stringWithString:parameter];
    }
    
    return encodedParameter;
}

-(NSString *) getOauthAuthorizationHeader
{
    NSMutableString * header = header = [NSMutableString string];
    
    if(self.url)
    {
        NSMutableArray * parameters = [NSMutableArray array];

        [parameters addObject:[NSString stringWithFormat:@"oauth_consumer_key=%@", self.consumerKey]];
        [parameters addObject:[NSString stringWithFormat:@"oauth_nonce=%@", self.nonce]];
        [parameters addObject:[NSString stringWithFormat:@"oauth_signature_method=HMAC-SHA1"]];
        [parameters addObject:[NSString stringWithFormat:@"oauth_timestamp=%@", self.timestamp]];
        
        if(self.oauthToken)
        {
            [parameters addObject:[NSString stringWithFormat:@"oauth_token=%@", self.oauthToken]];
        }
        
        [parameters addObject:[NSString stringWithFormat:@"oauth_version=%@", self.oauthVersion]];
        
        NSString * normalizedUrl = [Utilities urlDecode:[url absoluteString]];
        NSArray *splittedUrl = [normalizedUrl componentsSeparatedByString:@"?"];
        NSMutableString * signature = [NSMutableString string];

        if([splittedUrl count] == 2)
        {
            normalizedUrl = [splittedUrl objectAtIndex:0];
            NSString * queryString = [splittedUrl objectAtIndex:1];

            NSArray * queryParameters = [queryString componentsSeparatedByString:@"&"];
            
            StringComparator * comparator = [[StringComparator alloc] init];
            
            for(NSString * queryParameter in queryParameters)
            {
                [Utilities insertObject:[self encodeParameter:queryParameter] inArray:parameters withLowIndex:0
                             withHighIndex:[parameters count] - 1 usingComparator:comparator];
            }
        }
        
        NSString * parametersString = [parameters componentsJoinedByString:@"&"];

        [signature appendFormat:@"%@&%@&%@", @"GET", [Utilities urlEncode:normalizedUrl], [Utilities urlEncode:parametersString]];

        NSString * tokenSecret = (self.oauthTokenSecret) ? self.oauthTokenSecret : @"";
        
        NSString *oauthKey = [NSString stringWithFormat:@"%@&%@", consumerSecret, tokenSecret];

        NSData * signatureSHA1 = [Utilities calculateHMACSHA1:signature secret:oauthKey];

        NSString * base64signature = [Utilities base64forData:signatureSHA1];
        
        [header appendString:@"OAuth "];
        [header appendFormat:@"%@=\"%@\"", [Utilities urlEncode:@"oauth_consumer_key"], [Utilities urlEncode:self.consumerKey]];
        [header appendFormat:@", %@=\"%@\"",[Utilities urlEncode:@"oauth_nonce"], [Utilities urlEncode:self.nonce]];
        [header appendFormat:@", %@=\"%@\"", [Utilities urlEncode:@"oauth_signature"],[Utilities urlEncode:base64signature]];
        [header appendFormat:@", %@=\"%@\"", [Utilities urlEncode:@"oauth_signature_method"], [Utilities urlEncode:@"HMAC-SHA1"]];
        [header appendFormat:@", %@=\"%@\"", [Utilities urlEncode:@"oauth_timestamp"], [Utilities urlEncode:self.timestamp]];
        
        if(self.oauthToken)
        {
            [header appendFormat:@", %@=\"%@\"", [Utilities urlEncode:@"oauth_token"], [Utilities urlEncode:self.oauthToken]];
        }
        [header appendFormat:@", %@=\"%@\"", [Utilities urlEncode:@"oauth_version"], [Utilities urlEncode:self.oauthVersion]];
    }
    
    return header;
}

-(NSString *)description
{
    NSMutableString * descriptionString = [NSMutableString stringWithFormat:@"[OAuthData <%p>: ", self];
    
    [descriptionString appendFormat:@"URL: %@, ", self.url];
    [descriptionString appendFormat:@"CONS-KEY: %@, ", self.consumerKey];
    [descriptionString appendFormat:@"CONS-SEC: %@, ", self.consumerSecret];
    [descriptionString appendFormat:@"TK: %@, ", self.oauthToken];
    [descriptionString appendFormat:@"TK-SEC: %@, ", self.oauthTokenSecret];
    [descriptionString appendFormat:@"VER: %@, ", self.oauthVersion];
    [descriptionString appendFormat:@"METHOD: GET"];
    [descriptionString appendFormat:@"SIGN-METHOD: HMACSHA1"];
    [descriptionString appendFormat:@"TSTAMP: %@, ", self.timestamp];
    [descriptionString appendFormat:@"NONCE: %@]", self.nonce];

    return descriptionString;
}

@end
