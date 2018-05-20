//
//  SigmaURLLoader.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaURLLoader.h"

@interface SigmaURLLoader () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong) NSURLConnection *connection;

@end

@implementation SigmaURLLoader

@synthesize data = _data;
@synthesize connection = _connection;

- (id)init
{
    if (self = [super init])
    {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}

- (BOOL)load:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    return _connection != nil;
}

- (void)close
{
    if (_connection)
    {
        [_connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_URLLOADER_ERROR object:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_URLLOADER_COMPLETE object:self];
}

@end
