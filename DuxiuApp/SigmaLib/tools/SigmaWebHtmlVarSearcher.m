//
//  SigmaWebHtmlVarSearcher.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaWebHtmlVarSearcher.h"

@interface SigmaWebHtmlVarSearcher () <UIWebViewDelegate>

@property (strong) UIWebView *homeLoader;
@property (strong) UIWebView *searchLoader;

@end

@implementation SigmaWebHtmlVarSearcher

@synthesize homeLoader = _homeLoader;
@synthesize searchLoader = _searchLoader;

- (id)init
{
    return [self initWithWebView:nil];
}

- (SigmaWebHtmlVarSearcher *)initWithWebView:(UIWebView *)homeLoader
{
    if (self = [super init])
    {
        _homeLoader = homeLoader ? homeLoader : [[UIWebView alloc] init];
        _searchLoader = [[UIWebView alloc] init];
    }
    return self;
}

- (BOOL)searchVarWithURL:(NSString *)url andNames:(NSArray *)varNames
{
    if (_homeLoader && url)
    {
        self.searchVarNames = varNames;
        
        // begin search
        if (self.defaultWindow && [_homeLoader.request.URL.absoluteString isEqualToString:url])
        {
            [self doSearchVar];
        }
        else
        {
            self.defaultWindow = nil;
            _homeLoader.delegate = nil;
            [_homeLoader stopLoading];
            
            _homeLoader.delegate = self;
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [_homeLoader loadRequest:request];
        }
        return true;
    }
    return false;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == _homeLoader)
    {
        [self onHomePageLoaded];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView == _homeLoader)
    {
        [self onHomePageFailed];
    }
}

- (void)onHomePageLoaded
{
    _homeLoader.delegate = nil;
    
    [self fetchHomeLoaderData];
}

- (void)onHomePageFailed
{
    _homeLoader.delegate = nil;
    
    if (self.delegate)
        [self.delegate onSearchError];
}

//------------------------------------------------------
#define JAVASCRIPT_FORMAT @" \
var s = ''; \
for (var i in %@) \
{ \
    var t = typeof(%@[i]); \
    if (t != 'object' && t != 'function') \
    { \
        s += '&' + i + '=' + %@[i]; \
    } \
} \
s;"

NSString *getJavascript(NSString *target)
{
    NSString *script = [NSString stringWithFormat:JAVASCRIPT_FORMAT, target, target, target];
    return script;
}

/*
 *** WebKit discarded an uncaught exception in the webView:didFinishLoadForFrame: delegate: 
 <NSRangeException> -[__NSCFConstantString characterAtIndex:]: Range or index out of bounds
 */

NSMutableDictionary *parseData(NSString *text)
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    if ([text characterAtIndex:0] == '&')
    {
        text = [text substringFromIndex:1];
        NSArray *vars = [text componentsSeparatedByString:@"&"];
        for (NSString *item in vars) {
            NSArray *v = [item componentsSeparatedByString:@"="];
            NSString *varName = [v objectAtIndex:0];
            NSString *varValue = [v objectAtIndex:1];
            
            if ([varName characterAtIndex:0] == '_')
                varName = [varName substringFromIndex:1];
            
            if ([varValue isEqualToString:@"undefined"])
                [data setObject:@"" forKey:varName];
            else
                [data setObject:varValue forKey:varName];
        }
    }
    return data;
}

- (void)fetchHomeLoaderData
{
    NSString *windowData = [_homeLoader stringByEvaluatingJavaScriptFromString:getJavascript(@"window")];
    NSString *documentData = [_homeLoader stringByEvaluatingJavaScriptFromString:getJavascript(@"document")];
    
    self.defaultWindow = parseData(windowData);
    [self.defaultWindow setObject:parseData(documentData) forKey:@"document"];
    
    [self doSearchVar];
}

- (void)stopSearch
{
    [_searchLoader stopLoading];
}

@end
