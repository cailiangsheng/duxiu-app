//
//  SigmaHtmlVarSearcher.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SigmaHtmlVarSearcher.h"

#import "SigmaWebHtmlVarSearcher.h"
#import "SigmaTextHtmlVarSearcher.h"

@interface SigmaHtmlVarSearcher () <ISigmaHtmlVarSearchDelegate>

@property (strong) id<ISigmaHtmlVarSearcher> searcher;

@property (weak) id<ISigmaHtmlVarSearchDelegate> delegate;

@end

@implementation SigmaHtmlVarSearcher

@synthesize searcher = _searcher;

@synthesize delegate = _delegate;

- (id)init
{
    if (self = [super init])
    {
//        _searcher = [[SigmaWebHtmlVarSearcher alloc] init];
        _searcher = [[SigmaTextHtmlVarSearcher alloc] init];
        [_searcher setDelegate:self];
    }
    return self;
}

- (void)onSearchComplete
{
    if (_delegate)
        [_delegate onSearchComplete];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_HTMLVARSEARCHER_COMPLETE object:self];
}

- (void)onSearchError
{
    if (_delegate)
        [_delegate onSearchError];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_HTMLVARSEARCHER_ERROR object:self];
}

- (BOOL)searchVarWithURL:(NSString *)url andNameList:(NSString *)varName, ...
{
    NSMutableArray *varNames = nil;
    if (varName)
    {
        va_list varList;
        id arg;
        varNames = [[NSMutableArray alloc] initWithObjects:varName, nil];
        
        va_start(varList, varName);
        while ((arg = va_arg(varList, id)))
        {
            [varNames addObject:arg];
        }
        va_end(varList);
    }
    
    return [self searchVarWithURL:url andNames:varNames];
}

- (BOOL)searchVarWithURL:(NSString *)url andNames:(NSArray *)varNames
{
    return [_searcher searchVarWithURL:url andNames:varNames];
}

- (BOOL)searchVarWithURL:(NSString *)url andName:(NSString *)varName
{
    return [self searchVarWithURL:url andNameList:varName, nil];
}

- (NSString *)getVarPropWithName:(NSString *)propName
{
    return [_searcher getVarPropWithName:propName];
}

- (NSString *)getVarPropWithName:(NSString *)propName isReplaceFromHome:(BOOL)rfh
{
    return [_searcher getVarPropWithName:propName isReplaceFromHome:rfh];
}

- (NSString *)getVarPropWithName:(NSString *)propName isReplaceFromHome:(BOOL)rfh isDocumentProp:(BOOL)dp
{
    return [_searcher getVarPropWithName:propName isReplaceFromHome:rfh isDocumentProp:dp];
}

@end
