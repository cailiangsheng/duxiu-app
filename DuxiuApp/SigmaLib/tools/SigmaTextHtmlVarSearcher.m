//
//  SigmaTextHtmlVarSearcher.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaTextHtmlVarSearcher.h"

@interface SigmaTextHtmlVarSearcher () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong) NSString *url;
@property (strong) NSMutableData *homeData;

@property (strong) NSURLConnection *homeLoader;
@property (strong) NSURLConnection *searchLoader;

@end

@implementation SigmaTextHtmlVarSearcher

@synthesize url = _url;
@synthesize homeData = _homeData;

@synthesize homeLoader = _homeLoader;
@synthesize searchLoader = _searchLoader;

- (id)init
{
    if (self = [super init])
    {
        _homeLoader = [[NSURLConnection alloc] init];
        _searchLoader = [[NSURLConnection alloc] init];
        
        _homeData = [[NSMutableData alloc] init];
    }
    return self;
}

- (BOOL)searchVarWithURL:(NSString *)url andNames:(NSArray *)varNames
{
    if (_homeLoader && url)
    {
        self.searchVarNames = varNames;
        
        if (self.defaultWindow && [_url isEqualToString:url])
        {
            [self doSearchVar];
        }
        else
        {
            self.defaultWindow = nil;
            
            self.url = url;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            _homeLoader = [_homeLoader initWithRequest:request delegate:self startImmediately:YES];
        }
        return true;
    }
    return false;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connection == _homeLoader)
    {
        [self onHomePageFailed];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == _homeLoader)
    {
        [_homeData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == _homeLoader)
    {
        [_homeData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == _homeLoader)
    {
        if (_homeData.length > 0)
            [self onHomePageLoaded];
        else
            [self onHomePageFailed];
    }
}

- (void)onHomePageLoaded
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *text = [[NSString alloc] initWithData:_homeData encoding:encoding];
    
    if (text == nil || text.length == 0)
        text = [[NSString alloc] initWithData:_homeData encoding:NSUTF8StringEncoding];
    
    self.defaultWindow = fetchHomeLoaderWindowData(text);
    [self.defaultWindow setObject:fetchHomeLoaderDocumentData(text) forKey:@"document"];
    
    [self doSearchVar];
}

- (void)onHomePageFailed
{
    self.url = nil;
    
    if (self.delegate)
        [self.delegate onSearchError];
}

void collectHomeLoaderData(NSString *text, NSMutableDictionary *map, NSString *pattern, int nameIndex, int valueIndex)
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *results = [regexp matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *result in results) {
        NSRange nameRange = [result rangeAtIndex:nameIndex];
        NSRange valueRange = [result rangeAtIndex:valueIndex];
        
        NSString *varName = [text substringWithRange:nameRange];
        NSString *varValue  = [text substringWithRange:valueRange];
        
        [map setObject:varValue forKey:varName];
    }
}

NSMutableDictionary *fetchHomeLoaderWindowData(NSString *text)
{
    NSMutableDictionary *window = [[NSMutableDictionary alloc] init];
    collectHomeLoaderData(text, window, @"(\\w+)\\s*=\\s*(\\d+|true|false)\\s*[,;]", 1, 2);
    collectHomeLoaderData(text, window, @"(\\w+)\\s*=\\s*\"(([^\\\\\"]|(\\\\\")|(\\\\')|(\\\\\\\\))+)\"\\s*[,;]", 1, 2);
    collectHomeLoaderData(text, window, @"(\\w+)\\s*=\\s*'(([^\\\\']|(\\\\\")|(\\\\')|(\\\\\\\\))+)'\\s*[,;]", 1, 2);
    return window;
}

NSMutableDictionary *fetchHomeLoaderDocumentData(NSString *text)
{
    NSMutableDictionary *document = [[NSMutableDictionary alloc] init];
    collectHomeLoaderData(text, document, @"<(title)>(.*)</title>", 1, 2);
    return document;
}

@end
