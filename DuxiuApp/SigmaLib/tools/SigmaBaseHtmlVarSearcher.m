//
//  SigmaBaseHtmlVarSearcher.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaBaseHtmlVarSearcher.h"

@implementation SigmaBaseHtmlVarSearcher

@synthesize defaultWindow = _defaultWindow;
@synthesize searchVarNames = _searchVarNames;
@synthesize searchFrames = _searchFrames;
@synthesize searchNumFrames = _searchNumFrames;
@synthesize searchedWindow = _searchedWindow;

@synthesize delegate = _delegate;

- (void)doSearchVar
{
    _searchFrames = nil;
    _searchNumFrames = 0;
    _searchedWindow = nil;
    
    [self stopSearch];
    [self startSearch];
}

- (NSString *)getVarPropWithName:(NSString *)propName
{
    return [self getVarPropWithName:propName isReplaceFromHome:false];
}

- (NSString *)getVarPropWithName:(NSString *)propName isReplaceFromHome:(BOOL)rfh
{
    return [self getVarPropWithName:propName isReplaceFromHome:rfh isDocumentProp:false];
}

- (NSString *)getVarPropWithName:(NSString *)propName isReplaceFromHome:(BOOL)rfh isDocumentProp:(BOOL)dp
{
    if (_searchedWindow)
    {
        NSDictionary *map = _searchedWindow;
        if (map == nil && rfh)
            map = _defaultWindow;
        if (map != nil && dp)
            map = [map valueForKey:@"document"];
        
        if (map)
            return [map valueForKey:propName];
    }
    return nil;
}

- (void)onSearchedWindow:(id)window
{
    _searchedWindow = window;
    
    if (_delegate)
        [_delegate onSearchComplete];
}

- (void)startSearch
{
    NSDictionary *window = _defaultWindow;
    if (window)
    {
        for (NSString *varName in _searchVarNames)
        {
            for (NSString *key in [window allKeys])
            {
                if ([key isEqualToString:varName])
                {
                    [self onSearchedWindow:window];
                    return;
                }
            }
        }
    }
    
    [self doSearchFrames];
}

- (void)stopSearch
{
    // do nothing
}

- (void)doSearchFrames
{
    [self onSearchedWindow:nil];
}

@end
